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

# backup .zshrc .zprofile .config/nvim
mv ${HOME}/.zshrc ${DOTBACKUP}/zshrc.org
mv ${HOME}/.zprofile ${DOTBACKUP}/zprofile.org
mv ${HOME}/.zlogin ${DOTBACKUP}/zlogin.org
mv ${HOME}/.zlogout ${DOTBACKUP}/zlogout.org
mv ${HOME}/.zpreztorc ${DOTBACKUP}/zpreztorc.org
mv ${HOME}/.zshenv ${DOTBACKUP}/zshenv.org
mv ${HOME}/.gitconfig ${DOTBACKUP}/gitconfig.org
mv ${HOME}/.gitignore_global ${DOTBACKUP}/gitignore_global.org
mv ${XDG_CONFIG_HOME}/nvim ${DOTBACKUP}/nvim.org

# link dotfiles
cd ${HOME}
ln -s ${DOTDIR}/.zshrc
ln -s ${DOTDIR}/.zprofile
ln -s ${DOTDIR}/.zlogin
ln -s ${DOTDIR}/.zlogout
ln -s ${DOTDIR}/.zpreztorc
ln -s ${DOTDIR}/.zshenv
ln -s ${DOTDIR}/.gitconfig
ln -s ${DOTDIR}/.gitignore_global
ln -s ${DOTDIR}/.config/nvim ${XDG_CONFIG_HOME}

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
