# ---------------------------
# Setup -> homebrew, zsh iterm2 neovim
# ---------------------------

DOTDIR=${HOME}/Dev/dotfiles
DOTBACKUP=${HOME}/.dot_backup
XDG_CONFIG_HOME=${HOME}/.config

# install xcode, brew
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# restrict DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# git,neovim
brew update
brew upgrade
brew install git neovim

# install fonts
brew tap sanemat/font
brew tap homebrew/cask-fonts
brew install ricty
cp -f /opt/homebrew/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/

# clone dotfiles
git clone https://github.com/TomoyaFujita2016/dotfiles.git ${DOTDIR}

# prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# ctags
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
mkdir ${HOME}/.ctags.d
cp ./config.ctags.org ${HOME}/.ctags.d/config.ctags

# pyenv, virtualenv
brew install pyenv pyenv-virtualenv

# backup dotfiles
backup (){
    mv ${HOME}/$1 ${DOTBACKUP}/${1}.org
}
backup .zshrc
backup .zprofile
backup .zlogin
backup .zlogout
backup .zpreztorc
backup .zshenv
backup .gitconfig
backup .gitignore_global
backup .config/nvim

# link dotfiles
link_dot () {
    ln -s ${DOTDIR}/$1 $2
}
cd ${HOME}
link_dot .zshrc
link_dot .zprofile
link_dot .zlogin
link_dot .zlogout
link_dot .zpreztorc
link_dot .zshenv
link_dot .gitconfig
link_dot .gitignore_global
link_dot .config/nvim ${XDG_CONFIG_HOME}

# load .zshrc
source ${HOME}/.zshrc

# make python env for neovim
pyenv install 3.9.6
pyenv virtualenv 3.9.6 deinvim
pyenv shell deinvim
pip install -r ${DOTDIR}/dein_requirments.txt
pyenv shell --unset

# echo todo
echo 以下にチェックを入れて、\"${DOTDIR}\"を指定
echo "iterm2 > General > Preferences > Load preferences from a custom folder or url."
