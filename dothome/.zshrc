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

# ----------------------------
# Load Local Configuration
# ----------------------------
# Store PC-specific functions, aliases, and settings in ~/.zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
