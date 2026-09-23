{ config, lib, pkgs, ... }:
let
  # Exposed as a command as well as the timer's ExecStart, so a run can be
  # watched live in a terminal.
  triage = pkgs.writeShellScriptBin "llm-log-processing" ''
    export PATH=${lib.makeBinPath [
      pkgs.coreutils
      pkgs.curl
      pkgs.gawk
      pkgs.gnugrep
      pkgs.gnused
      pkgs.jq
      pkgs.libnotify
      pkgs.systemd
    ]}:$PATH
    set -euo pipefail

    state=''${STATE_DIRECTORY:-$HOME/.local/state/llm-log-processing}
    digest=$state/digest.txt
    new=$state/new.txt
    baseline=$state/baseline.txt
    report=$state/report.md
    candidates=$state/candidates.txt
    model=${lib.escapeShellArg config.polaris.logModel}
    api=http://127.0.0.1:11434/api/generate

    mkdir -p "$state"
    touch "$baseline"
    rm -f "$state"/chunk.*

    # ollama-model-loader reports itself started as soon as the download
    # begins, so systemd ordering cannot express "the model is ready".
    # Poll for it instead; a first pull is several GB.
    ready=
    for _ in $(seq 1 180); do
      if curl -sf --max-time 10 http://127.0.0.1:11434/api/tags \
           | jq -e --arg m "$model" '.models[]? | select(.name == $m)' >/dev/null
      then
        ready=1
        break
      fi
      sleep 10
    done

    if [ -z "$ready" ]; then
      echo "Model $model still unavailable after 30 minutes." >&2
      exit 1
    fi

    # Every priority, not just errors: the map pass below reads the digest in
    # chunks, so total size is bounded by time rather than by context.
    # Keep the emitting unit alongside the message so a finding can be traced
    # back to what produced it. Pids, hashes and bare numbers are normalised
    # so repeats collapse into one counted template.
    journalctl -b --no-pager -q \
        -o json \
        --output-fields=_SYSTEMD_UNIT,_SYSTEMD_USER_UNIT,SYSLOG_IDENTIFIER,MESSAGE \
      | jq -r 'def norm:
                 gsub("(?<p>\\[[0-9]+\\])|(?<h>[0-9a-f]{8,})|(?<a>([0-9]{1,3}\\.){3}[0-9]{1,3})|(?<n>[0-9]+)";
                      if .p then "[P]" elif .h then "HEX" elif .a then .a else "N" end);
               select(.MESSAGE | type == "string")
               | "\(._SYSTEMD_USER_UNIT // ._SYSTEMD_UNIT // "-")[\(.SYSLOG_IDENTIFIER // "-")]\t\(.MESSAGE | gsub("\n"; " ") | norm)"' \
      | sed -E 's/[[:space:]]+$//' \
      | sed '/^$/d' \
      | sort | uniq -c | sort -rn > "$digest"

    sed -E 's/^[[:space:]]*[0-9]+[[:space:]]//' "$digest" | sort -u > "$state/today.txt"
    comm -23 "$state/today.txt" "$baseline" > "$new"

    if [ ! -s "$digest" ]; then
      echo "Nothing in the journal since boot." > "$report"
      exit 0
    fi

    # comm gives the new templates without their counts; put the counts back,
    # since how often something happened is part of reading it.
    awk 'NR == FNR { seen[$0] = 1; next }
         { key = $0
           sub(/^[[:space:]]*[0-9]+[[:space:]]+/, "", key)
           if (key in seen) print }' \
      "$new" "$digest" > "$state/new-counted.txt"

    total_templates=$(wc -l < "$digest")
    new_templates=$(wc -l < "$state/new-counted.txt")
    recurring=$((total_templates - new_templates))

    # The diff gates everything. A quiet run reaches the model not at all,
    # and a busy one only shows it what actually changed — scanning the whole
    # digest every time just to discard it was most of the runtime.
    if [ ! -s "$state/new-counted.txt" ]; then
      {
        echo "Nothing new since the last run."
        echo
        echo "$recurring known message templates, unchanged. Most frequent:"
        echo
        sort -rn "$digest" | head -5 | sed 's/^/    /'
      } > "$report"
      cp "$state/today.txt" "$baseline"
      notify-send "Log triage" "Nothing new. $recurring known templates." || true
      exit 0
    fi

    # MAP: scan the new templates in fixed-size chunks, keeping only lines that
    # look like real problems. Thinking is off here — this pass is a filter,
    # and reasoning on every chunk would dominate the runtime.
    split -l 120 "$state/new-counted.txt" "$state/chunk."
    set -- "$state"/chunk.*
    total=$#
    : > "$candidates"
    n=0

    for chunk in "$state"/chunk.*; do
      n=$((n + 1))
      # Progress only on a terminal: under systemd this would be one journal
      # record per chunk.
      [ -t 2 ] && printf '\r[%d/%d] scanning %d templates...' \
        "$n" "$total" "$(wc -l < "$chunk")" >&2 || true

      jq -n \
        --arg model "$model" \
        --rawfile chunk "$chunk" \
        '{
          model: $model,
          stream: false,
          think: false,
          options: { temperature: 0, num_ctx: 16384 },
          prompt: (
            "Deduplicated systemd journal templates. Each line is: count, then "
            + "unit[program], then a tab, then the message. Numbers, pids and "
            + "hashes are replaced with N, [P] and HEX.\n\n"
            + $chunk
            + "\n---\n"
            + "Copy out only the lines above that indicate a real problem: "
            + "failures, crashes, refused permissions, unreachable resources, "
            + "hardware faults. Ignore routine status, cosmetic warnings and "
            + "deprecation notices. Copy each line exactly as written, one per "
            + "line, with no commentary. Write NONE if no line qualifies.\n"
          )
        }' \
        | curl -sSf --max-time 3600 --data-binary @- "$api" \
        | jq -r '.response' >> "$candidates"
    done

    [ -t 2 ] && printf '\r[%d/%d] scanned. reducing...\n' "$total" "$total" >&2 || true
    sed -E '/^[[:space:]]*(NONE|)[[:space:]]*$/d' -i "$candidates"

    # Every new template may still be routine; if the map pass kept none,
    # there is nothing to explain.
    if [ ! -s "$candidates" ]; then
      {
        echo "$new_templates new message templates since the last run, none"
        echo "of which look like problems. $recurring known templates unchanged."
      } > "$report"
      cp "$state/today.txt" "$baseline"
      rm -f "$state"/chunk.*
      notify-send "Log triage" "$new_templates new, nothing notable." || true
      exit 0
    fi

    # REDUCE: one pass over just the candidates.
    jq -n \
      --arg model "$model" \
      --rawfile candidates "$candidates" \
      --arg recurring "$recurring" \
      --rawfile new "$new" \
      '{
        model: $model,
        stream: true,
        think: false,
        options: { temperature: 0, num_ctx: 16384 },
        prompt: (
          "Error lines from a NixOS workstation journal. Every line below "
          + "appeared for the FIRST time since the last run — that is already "
          + "established, you do not need to assess whether they are new or "
          + "important. Each line is: a count, then unit[program], then a tab, "
          + "then the message. Numbers, pids and hashes are replaced with N, "
          + "[P] and HEX.\n\n"
          + $candidates
          + "\n---\n"
          + "Your job is to EXPLAIN these lines, not to rank them.\n\n"
          + "Group the lines by root cause. Several lines with one underlying "
          + "cause (for example every DNS lookup that failed while the network "
          + "was still coming up) form ONE group, however different the "
          + "services are.\n\n"
          + "Reply in exactly this format and nothing else:\n\n"
          + "## <short cause, e.g. DNS unavailable during boot>\n"
          + "At most THREE log lines from the group, copied exactly, one per "
          + "line. If the group holds more, follow them with one line giving "
          + "the real count, e.g. (+2 more of the same). Do not write a heading "
          + "above the lines.\n"
          + "Then one sentence on what caused them, and one sentence on "
          + "whether it clears on its own. Say plainly when you do not know; "
          + "that is a better answer than a guess. Do NOT recommend fixes, "
          + "packages, commands or config changes: you cannot see this system "
          + "and the suggestion would be invented.\n\n"
          + "Repeat for each group. Never invent a log line.\n"
        )
      }' > "$state/request.json"

    # Streamed so reasoning is visible as it is produced; the raw NDJSON is
    # kept so the report and the thinking can be reconstructed afterwards.
    curl -sSf --no-buffer --max-time 3600 --data-binary @"$state/request.json" "$api" \
      | tee "$state/raw.ndjson" \
      | jq -j --unbuffered '.thinking // .response // ""'

    echo

    jq -j '.response // ""' "$state/raw.ndjson" > "$report.tmp"
    jq -r '.prompt' "$state/request.json" > "$state/prompt.txt"

    printf '\n---\n%s recurring error templates unchanged since the last run.\n' \
      "$recurring" >> "$report.tmp"

    mv "$report.tmp" "$report"
    cp "$state/today.txt" "$baseline"
    rm -f "$state"/chunk.*

    notify-send "Log triage done" "$(wc -l < "$new") new message types. $report" || true
  '';
in
lib.mkIf config.polaris.features.llmLogProcessing {
  environment.systemPackages = [ triage ];

  systemd.user.services.llm-log-processing = {
    description = "Journal triage via local LLM";

    serviceConfig = {
      Type = "oneshot";
      StateDirectory = "llm-log-processing";
      # Runs unprivileged: it reads the journal via the wheel group, talks to
      # ollama over localhost, and writes only its own state directory. The
      # model's output is never evaluated, only written to a file.
      ExecStart = "${triage}/bin/llm-log-processing";
      # The report is the artifact; streaming it into the journal as well
      # would just duplicate it. Errors still surface via stderr.
      # Building the digest chews through the whole journal; keep it behind
      # anything interactive.
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";

      StandardOutput = "null";
      # StandardError defaults to inherit, which would follow StandardOutput
      # into /dev/null and hide every failure.
      StandardError = "journal";

      ProtectSystem = "strict";
      PrivateTmp = true;
      NoNewPrivileges = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" ];
      SystemCallFilter = [ "@system-service" ];
    };
  };

  systemd.user.timers.llm-log-processing = {
    description = "Journal triage after boot, then twice a day";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # OnStartupSec rather than OnBootSec: for a user unit the reference
      # point is the user manager starting, which is what we want.
      OnStartupSec = "5m";
      OnUnitActiveSec = "12h";
    };
  };
}
