#
# .zshenv - Environment variables for all zsh processes
# Defines environment variables needed by all shells (interactive & non-interactive)
#

# ----------------------------
# Basic Environment Variables
# ----------------------------
# Locale settings removed - using system defaults
# LC_ALL removed to avoid locale warnings
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# ----------------------------
# XDG Base Directory
# ----------------------------
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# ----------------------------
# Tool Root Directories
# ----------------------------
export PYENV_ROOT=$HOME/.pyenv
export CARGO_HOME=$HOME/.cargo

# ----------------------------
# Terminal Settings
# ----------------------------
export TERM=xterm-256color

# ----------------------------
# Less Configuration
# ----------------------------
# -g: Highlight only last match during search
# -i: Case-insensitive search
# -M: Verbose prompt
# -R: Interpret ANSI color escape sequences
# -S: Don't wrap long lines
# -w: Highlight new lines
# -X: Don't clear screen on exit
# -z-4: Window size for scrolling
export LESS='-g -i -M -R -S -w -X -z-4'

# Less input preprocessor
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# ----------------------------
# Load Local Environment Variables
# ----------------------------
# Store sensitive info and PC-specific variables in ~/.zshenv.local
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
