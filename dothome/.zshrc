#
# .zshrc - Interactive shell configuration
# Aliases, prompt, completion, plugins, and other UI-related settings
#

# ----------------------------
# History Management
# ----------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000

# History options
setopt inc_append_history       # Append history on command execution
setopt no_share_history         # Each session has its own history
setopt hist_ignore_all_dups     # Don't show duplicates
setopt hist_save_no_dups        # Delete older duplicates when saving
setopt extended_history         # Record timestamp
setopt hist_expire_dups_first   # Remove duplicates first when HISTSIZE exceeded

# ----------------------------
# Zinit Plugin Manager
# ----------------------------
# Install Zinit (if not exists)
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Load Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ----------------------------
# Zinit Plugins
# ----------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/history-search-multi-word

# ----------------------------
# Key Bindings
# ----------------------------
# Shift-Tab to accept autosuggestion
bindkey '^[[Z' autosuggest-accept

# ----------------------------
# Aliases
# ----------------------------
# Basic commands
alias vi="nvim"
alias ls='ls --color=auto -G'
alias ll='ls -lG'
alias la='ls -lAG'

# Clipboard
alias cb='xsel -bi'

# tmux
alias ta='tmux attach || tmux'

# Directory navigation
alias nvimconf='cd ~/.config/nvim/'

# Scripts
alias ide="~/.scripts/ide.sh"

# Safe deletion (use trash-put if available)
if type trash-put &> /dev/null; then
    alias rm='trash-put'
else
    alias rm='rm -i'
fi

# Git
alias glg='git log --pretty="format:%C(yellow)%h %C(red)%d %C(reset)%s %C(cyan)@%an %C(green)%cd" --date=format:"%y/%m/%d" --all --graph'

# Utilities
alias fontResize='sh ~/.scripts/calc_fontsize.sh'
alias stopPortContainer='~/.scripts/stop-port-docker-container.sh'

# webm to mp4 conversion
alias webm2mp4='function _webm2mp4() {
  ffmpeg -i "$1" \
    -vf "crop=iw-mod(iw\,2):ih-mod(ih\,2):0:0" \
    -c:v libx264 \
    -preset veryslow \
    -crf 18 \
    -profile:v high \
    -movflags +faststart \
    -pix_fmt yuv420p \
    -vsync vfr \
    -copyts \
    "${1%.*}.mp4"
}; _webm2mp4'


# ----------------------------
# Common Functions
# ----------------------------
# Concatenate files and copy to clipboard
function cat2cb() {
  local dir=$1
  shift
  local extensions=("$@")

  if [ ${#extensions[@]} -eq 0 ]; then
    echo -e "[catf2cb] \e[33mUsage: catf2cb <directory> <extension1> [<extension2> ...]\e[m"
    return 1
  fi

  local find_expr="-false"
  for ext in "${extensions[@]}"; do
    find_expr+=" -o -name \"*.$ext\""
  done

  echo -e "[catf2cb] \e[35mfind ${dir} $find_expr\e[m"

  local copied_lines=$(eval "find \"$dir\" -type f \\( $find_expr \\) -print0" | xargs -0 -I {} sh -c 'echo "# {}"; cat "{}"' | wc -l)
  eval "find \"$dir\" -type f \\( $find_expr \\) -print0" | xargs -0 -I {} sh -c 'echo "# {}\n\`\`\`"; cat "{}"; echo "\`\`\`\n"' | xclip -selection clipboard

  echo -e "[catf2cb] \e[32mCopied to clipboard! (${copied_lines} lines)\e[m"
}

# Update Discord
function updateDiscord() {
    wget https://discord.com/api/download/stable\?platform\=linux\&format\=deb -O /tmp/discord-update.deb && \
    sudo apt install -y /tmp/discord-update.deb
}

# Countdown timer: background sleep with desktop notification + sound on
# start and finish, plus a live remaining-time readout in the right prompt.
#   timer 120     # 120 秒のタイマー（2 分）
#   timer stop    # 実行中のタイマーを中断
zmodload zsh/datetime 2>/dev/null   # $EPOCHSECONDS

# 通知＋効果音（音はデタッチして即座に制御を返す）
_timer_alert() {  # _timer_alert <title> <body>
  command -v notify-send >/dev/null 2>&1 && notify-send "$1" "$2"
  local snd=/usr/share/sounds/freedesktop/stereo/dialog-information.oga
  [[ -f $snd ]] && command -v paplay >/dev/null 2>&1 && { paplay "$snd" &>/dev/null &! }
}

# 残り時間を計算して RPROMPT を組み立てる（終了時は元へ戻して TMOUT 解除）
_timer_render() {
  [[ -n $TIMER_END ]] || return
  local left=$(( TIMER_END - EPOCHSECONDS ))
  if (( left > 0 )); then
    RPROMPT="${TIMER_BASE_RPROMPT}%F{yellow}⏳$(printf '%d:%02d' $((left/60)) $((left%60)))%f"
  else
    RPROMPT=$TIMER_BASE_RPROMPT
    unset TIMER_END TMOUT
  fi
}

# TMOUT=1 が有効な間、1 秒ごとに SIGALRM が届く → プロンプトを再描画
TRAPALRM() {
  [[ -n $TIMER_END ]] || return
  _timer_render
  zle && zle reset-prompt
}

timer() {
  emulate -L zsh
  if [[ -z $1 || $1 == -h || $1 == --help ]]; then
    echo "Usage: timer SECONDS | timer stop   (例: timer 120)"
    return 1
  fi
  if [[ $1 == stop ]]; then
    if [[ -n $TIMER_END ]]; then
      [[ -n $TIMER_PID ]] && kill "$TIMER_PID" 2>/dev/null
      RPROMPT=$TIMER_BASE_RPROMPT
      unset TIMER_END TIMER_PID TMOUT
      echo "timer: 中断しました"
    else
      echo "timer: 実行中のタイマーはありません"
    fi
    return
  fi
  local secs=$1
  [[ -n $TIMER_END ]] && RPROMPT=$TIMER_BASE_RPROMPT   # 二重起動時は素の RPROMPT へ戻す
  TIMER_END=$(( EPOCHSECONDS + secs ))
  TIMER_BASE_RPROMPT=$RPROMPT          # starship が設定した元の右プロンプト（$(...) 文字列）を退避

  { sleep "$secs"; _timer_alert "⏰ タイマー終了" "${secs}秒経過しました"; } &!
  TIMER_PID=$!

  _timer_alert "⏱ タイマー開始" "${secs}秒"
  _timer_render        # RPROMPT を即セット（次の描画で表示）
  TMOUT=1              # アイドル中 1 秒ごとに TRAPALRM を発火させライブ更新
  echo "timer: ${secs}秒のタイマーを起動 (stop で中断)"
}


# ----------------------------
# Starship Prompt
# ----------------------------
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
fi

# ----------------------------
# direnv
# ----------------------------
if command -v direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# ----------------------------
# tmux auto-start
# ----------------------------
if [ $SHLVL = 1 ]; then
    tmux a -t main
    tmux_return=$?
    if [ $tmux_return = 1 ]; then
        tmux new-session -s main
    fi
fi

# ----------------------------
# git worktree
# ----------------------------
worktree() {
  local selected
  selected=$(git worktree list | fzf --height 40% | awk '{print $1}')
  if [[ -n "$selected" ]]; then
    cd "$selected" || return
    # tmux使用中なら window名を変更
    if [[ -n "$TMUX" ]]; then
      tmux rename-window "$(basename "$selected")"
    fi
  fi
}
alias wt=worktree

tmux-worktree() {
  local selected repo branch name
  selected=$(git worktree list | fzf --height 40% | awk '{print $1}')
  if [[ -n "$selected" ]]; then
    # 親ディレクトリ名(repository) + worktree名(branch)
    repo=$(basename "$(dirname "$selected")")
    branch=$(basename "$selected")
    name="${branch} (${repo})"
    
    if tmux has-session -t "$name" 2>/dev/null; then
      if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$name"
      else
        tmux attach-session -t "$name"
      fi
    else
      if [[ -n "$TMUX" ]]; then
        tmux new-session -d -s "$name" -c "$selected"
        tmux switch-client -t "$name"
      else
        tmux new-session -s "$name" -c "$selected"
      fi
    fi
  fi
}
alias tw=tmux-worktree


# ----------------------------
# tmux new session
# ----------------------------
tmux-create-new-session() {
  if [ -n "$TMUX" ]; then
    # When inside tmux: Create a session before switching 
    tmux new-session -d -s "$1"
    tmux switch-client -t "$1"
  else
    # When outside of tmux: Create a new session
    tmux new-session -s "$1"
  fi
}
alias tns=tmux-create-new-session

# Git worktree setup function
# Usage: git-worktree-setup <repository_url> [directory_name]
git-worktree-setup() {
    local repo_url="$1"
    local dir_name="${2:-$(basename "$repo_url" .git)}"
    
    if [[ -z "$repo_url" ]]; then
        echo "Usage: git_worktree_setup <repository_url> [directory_name]"
        return 1
    fi
    
    # 1. Clone bare
    git clone --bare "$repo_url" "$dir_name/.bare"
    
    # 2. Setup .git file
    echo "gitdir: .bare" > "$dir_name/.git"
    
    # 3. Configure fetch and fetch
    git -C "$dir_name/.bare" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git -C "$dir_name" fetch origin
    
    # 4. Get default branch and create worktree
    local default_branch
    default_branch=$(git -C "$dir_name" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
    [[ -z "$default_branch" ]] && default_branch="main"
    
    git -C "$dir_name/.bare" worktree add "../$default_branch" "$default_branch" 2>/dev/null || \
    git -C "$dir_name/.bare" worktree add "../main" main 2>/dev/null || \
    git -C "$dir_name/.bare" worktree add "../master" master
    
    echo "✅ Setup complete: $dir_name"

}
alias gws=git-worktree-setup


# git-worktree-add: Git Worktree Add (create branch if not exists)
# Usage: git-worktree-add <branch_name> [base_branch]
worktree-add() {
    local branch_name="$1"
    local base_branch="${2:-}"

    if [[ -z "$branch_name" ]]; then
        echo "Usage: git-wta <branch_name> [base_branch]"
        return 1
    fi

    # Find .bare directory
    local root_dir="$PWD"
    while [[ "$root_dir" != "/" ]]; do
        [[ -d "$root_dir/.bare" ]] && break
        root_dir=$(dirname "$root_dir")
    done
    
    if [[ ! -d "$root_dir/.bare" ]]; then
        echo "❌ .bare not found"
        return 1
    fi

    local worktree_path="$root_dir/$branch_name"
    
    if [[ -d "$worktree_path" ]]; then
        echo "⚠️  Already exists: $worktree_path"
        return 1
    fi

    cd "$root_dir/.bare" || return 1
    
    if git show-ref --quiet "refs/heads/$branch_name" || git show-ref --quiet "refs/remotes/origin/$branch_name"; then
        # Branch exists
        git worktree add "../$branch_name" "$branch_name"
    else
        # Create new branch
        local base="${base_branch:-HEAD}"
        git worktree add -b "$branch_name" "../$branch_name" "$base"
    fi
    
    cd - > /dev/null

    # Copy .env files from existing worktrees
    local source_worktree
    source_worktree=$(git -C "$root_dir/.bare" worktree list | awk '{print $1}' | grep -v "\.bare$" | grep -v "/$branch_name$" | head -n1)

    if [[ -n "$source_worktree" && -d "$source_worktree" ]]; then
        local copied=0
        while IFS= read -r env_file; do
            local relative_path="${env_file#$source_worktree/}"
            local target_file="$worktree_path/$relative_path"
            local target_dir=$(dirname "$target_file")

            mkdir -p "$target_dir"
            cp "$env_file" "$target_file"
            echo "📋 Copied: $relative_path"
            ((copied++))
        done < <(find "$source_worktree" -name ".env*" -type f 2>/dev/null)

        [[ $copied -gt 0 ]] && echo "📋 Copied $copied .env file(s)"
    fi

    echo "✅ Created: $worktree_path"
}

alias wa=worktree-add

alias ccusage="~/.claude/bin/claude-usage"


# ----------------------------
# Load Local Configuration
# ----------------------------
# Store PC-specific functions, aliases, and settings in ~/.zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
