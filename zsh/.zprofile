#
# .zprofile - Login shell configuration
# PATH setup and tool initialization
#

# ----------------------------
# PATH Configuration (with deduplication)
# ----------------------------
# typeset -U automatically removes duplicates from arrays
typeset -U path

# Add to PATH (in priority order)
path=(
  $HOME/.local/bin
  $PYENV_ROOT/bin
  $HOME/.nodenv/bin
  $HOME/.cargo/bin
  /usr/local/bin
  /usr/local/sbin
  $path
)

# ----------------------------
# MANPATH Configuration
# ----------------------------
typeset -U manpath
manpath=(
  $HOME/.local/share/man
  $manpath
)

# ----------------------------
# Tool Initialization
# ----------------------------
# Initialize pyenv (after PATH setup)
if command -v pyenv > /dev/null; then
  eval "$(pyenv init --path)"
fi

# Initialize nodenv
if command -v nodenv > /dev/null; then
  eval "$(nodenv init -)"
fi

# ----------------------------
# Load Local Initialization
# ----------------------------
# Store PC-specific PATH additions and initialization in ~/.zprofile.local
[ -f ~/.zprofile.local ] && source ~/.zprofile.local
