set -g fish_greeting 
nitch
if status is-interactive
    # --- ALIASES (Converted to Abbreviations) ---
    
    # General
    abbr --add .. 'cd ..'
    abbr --add mkdir 'mkdir -p'
    abbr --add n nvim
    abbr --add vs code
    abbr --add c clear
    abbr --add csync 'bash ~/PolarisOs/scripts/sync.sh'
    
    # Eza (List)
    abbr --add l 'eza -lh --icons=always'
    abbr --add ls 'eza -1 --icons=always'
    abbr --add ll 'eza -lha --icons=always --sort=name --group-directories-first'
    abbr --add ld 'eza -lhD --icons=always'
    abbr --add lt 'eza --icons=always --tree'
    
    # Tools
    abbr --add y yazi
    abbr --add m rmpc
    abbr --add lzg lazygit
    abbr --add lzd lazydocker
    
    # Git
    abbr --add ga 'git add'
    abbr --add gc 'git commit'
    abbr --add gs 'git status -s'
    abbr --add gl 'git log'
    abbr --add gp 'git push'
    
    # Navigation & Nix
    abbr --add flake 'cd ~/PolarisOS'
    abbr --add ws 'cd ~/PolarisSpace'
    abbr --add np 'nix profile'
    abbr --add tm tmux
    abbr --add ta 'tmux a'

    # --- COMPLEX ALIASES ---
    # In Fish, "&&" becomes "; and", "$()" becomes "()"
    
    function notesync
        cd ~/GrandArchive
        and git add .
        and git commit -m (date)
        and git push origin main --force
    end

    # --- FUNCTIONS ---

    # Note Function
    function note
        set -l session "Notes"
        set -l dir "$HOME/GrandArchive"

        if tmux has-session -t "$session" 2>/dev/null
            if set -q TMUX
                # Already inside tmux
                tmux switch-client -t "$session"
            else
                # Outside tmux
                tmux attach-session -t "$session" -c "$dir"
            end
            return
        end

        # Session does not exist
        if set -q TMUX
            tmux new-session -d -s "$session" -c "$dir" "nvim Polaris.md"
            tmux switch-client -t "$session"
        else
            tmux new-session -s "$session" -c "$dir" "nvim Polaris.md"
        end
    end

    # Fuzzy Navigation (cdf)
    function cdf
        set -l base $argv[1]
        # If no argument provided, default to HOME
        if test -z "$base"
            set base $HOME
        end
        
        set -l pick (fd -t d -H . "$base" | fzf --height=40% --reverse --prompt='cd → ' --preview 'ls -la {} | head -200')
        
        if test -n "$pick"
            cd "$pick"
        end
    end

    # Fuzzy Open (fo)
    function fo
        set -l base $argv[1]
        if test -z "$base"
            set base $HOME
        end

        set -l pick (fd -t f -H . "$base" | fzf --height=40% --reverse --prompt='open → ' --preview 'bat --style=plain --color=always --line-range=:200 {} 2>/dev/null || head -200 {}')
        
        if test -n "$pick"
            # Use standard EDITOR var or default to nvim
            eval $EDITOR $pick 2>/dev/null; or nvim "$pick"
        end
    end

    # Fuzzy Find (ff)
    function ff
        set -l base $argv[1]
        if test -z "$base"
            set base $HOME
        end

        set -l pick (fd -t f -H . "$base" | fzf --height=40% --reverse --prompt='find → ' --preview 'bat --style=plain --color=always --line-range=:200 {} 2>/dev/null || head -200 {}')
        
        if test -n "$pick"
            echo "$pick"
        end
    end

end
