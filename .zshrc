#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
function fzf-checkout-branch() {
  local branches branch
  branches=$(git branch | sed -e 's/\(^\* \|^  \)//g' | cut -d " " -f 1) &&
  branch=$(echo "$branches" | fzf --preview "git show --color=always {}") &&
  git checkout $(echo "$branch")
}
zle     -N   fzf-checkout-branch
alias vi='nvim'
alias vif='nvim $(fzf)'

export CPPFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"

export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYTHON_CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl) ${PYTHON_CONFIGURE_OPTS}"
export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I$(brew --prefix tcl-tk)/include' ${PYTHON_CONFIGURE_OPTS}"
export PYTHON_CONFIGURE_OPTS="--with-tcltk-libs='-L$(brew --prefix tcl-tk)/lib -ltcl8.6 -ltk8.6' ${PYTHON_CONFIGURE_OPTS}"

export PATH="/opt/homebrew/opt/tcl-tk/bin:$PATH"

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export XDG_CONFIG_HOME="$HOME/.config"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
