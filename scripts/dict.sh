#!/usr/bin/env bash
# Look up the primary-selection (highlighted) word and show a notification.

word=$(wl-paste --primary --no-newline | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
[ -z "$word" ] && { notify-send "Dictionary" "No word selected"; exit 0; }

enc=$(jq -rn --arg w "$word" '$w|@uri')
json=$(curl -fsS "https://api.dictionaryapi.dev/api/v2/entries/en/$enc")
if [ $? -ne 0 ] || [ -z "$json" ]; then
  notify-send "Dictionary: $word" "No definition found"
  exit 0
fi

body=$(printf '%s' "$json" | jq -r '
  .[0] as $e
  | ($e.phonetic // "") as $ph
  | [ $e.meanings[]
      | .partOfSpeech as $pos
      | .definitions[0].definition
      | "(" + $pos + ") " + .
    ] | .[0:3] | join("\n")
' 2>/dev/null)

[ -z "$body" ] && body="No definition found"
notify-send "📖 $word" "$body"
