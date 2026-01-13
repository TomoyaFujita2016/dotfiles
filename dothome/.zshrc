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

worktree-session() {
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
alias wts=worktree-session


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

    # Create directory structure
    mkdir -p "$dir_name"
    cd "$dir_name" || return 1
 
    # Clone as bare repository into .git
    git clone --bare "$repo_url" .git
 
    # Configure bare repository for worktree usage
    git config core.bare false
    git config core.worktree ..
 
    # Create main branch worktree
    local default_branch
    default_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")

    # Checkout main/master branch as primary worktree
    git worktree add main "$default_branch" 2>/dev/null || \
    git worktree add main master 2>/dev/null || \
    git worktree add main "$(git branch -r | head -1 | sed 's/.*\///')"
 
    echo "✅ Setup complete: $dir_name"
    echo "   Bare repo: $dir_name/.git"
    echo "   Worktree:  $dir_name/main"

    cd ..
}
alias gws=git-worktree-setup


# git-worktree-add: Git Worktree Add (create branch if not exists)
# Usage: git-worktree-add <branch_name> [base_branch]
git-worktree-add() {
    local branch_name="$1"
    local base_branch="${2:-HEAD}"

    if [[ -z "$branch_name" ]]; then
        echo "Usage: git-wta <branch_name> [base_branch]"
        echo "  Creates a worktree for the branch (creates branch if it doesn't exist)"
        return 1
    fi

    # Find the root .git directory (bare repo parent)
    _find_worktree_root() {
        local dir="$PWD"
        
        while [[ "$dir" != "/" ]]; do
            # Check if this directory has a .git that is a bare repo style
            if [[ -d "$dir/.git" ]]; then
                if [[ -d "$dir/.git/worktrees" ]] || grep -q "bare = false" "$dir/.git/config" 2>/dev/null; then
                    echo "$dir"
                    return 0
                fi
            fi
            
            # Check if we're inside a worktree (has .git file pointing to main repo)
            if [[ -f "$dir/.git" ]]; then
                local git_dir main_git_dir
                git_dir=$(cat "$dir/.git" | sed 's/gitdir: //')
                main_git_dir=$(cd "$dir" && cd "$(dirname "$git_dir")" && pwd)
                echo "$(dirname "$(dirname "$main_git_dir")")"
                return 0
            fi
            
            dir=$(dirname "$dir")
        done
        
        return 1
    }

    local root_dir
    root_dir=$(_find_worktree_root)

    if [[ -z "$root_dir" ]]; then
        echo "❌ Error: Could not find worktree root directory"
        return 1
    fi

    echo "📁 Worktree root: $root_dir"

    local worktree_path="$root_dir/$branch_name"

    if [[ -d "$worktree_path" ]]; then
        echo "⚠️  Worktree already exists: $worktree_path"
        return 1
    fi

    # Check if branch exists (local or remote)
    if git -C "$root_dir" show-ref --verify --quiet "refs/heads/$branch_name" 2>/dev/null; then
        echo "🔀 Using existing local branch: $branch_name"
        git -C "$root_dir" worktree add "$worktree_path" "$branch_name"
    elif git -C "$root_dir" show-ref --verify --quiet "refs/remotes/origin/$branch_name" 2>/dev/null; then
        echo "🔀 Tracking remote branch: origin/$branch_name"
        git -C "$root_dir" worktree add "$worktree_path" "$branch_name"
    else
        echo "🌱 Creating new branch: $branch_name (from $base_branch)"
        git -C "$root_dir" worktree add -b "$branch_name" "$worktree_path" "$base_branch"
    fi

    echo "✅ Worktree created: $worktree_path"
}

alias gwa=git-worktree-add


# ----------------------------
# Load Local Configuration
# ----------------------------
# Store PC-specific functions, aliases, and settings in ~/.zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
