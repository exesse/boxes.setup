#!/bin/bash

# Check current OS and make sure it is supported
OS_VERSION=$(uname -v)
_progress=0
_end=100

# Identify working environment
if [[ ${OS_VERSION} =~ "Darwin" ]]; then
   OS_VERSION="Darwin"
elif [[ ${OS_VERSION} =~ "Ubuntu" ]]; then
   OS_VERSION="Ubuntu"
elif [[ ${OS_VERSION} =~ "Debian" ]]; then
   OS_VERSION="Debian"
else
    echo 'ERROR: OS is not supported. Exiting installer now.'
    exit 1
fi

# Progress Bar function. Adopted from the code found here:
# https://github.com/fearside/ProgressBar/blob/master/progressbar.sh
ProgressBar () {
	let _progress=(${1}*100/${2}*100)/100
	let _done=(${_progress}*4)/10
	let _left=40-$_done

	_done=$(printf "%${_done}s")
	_left=$(printf "%${_left}s")

printf "\rProgress : [${_done// /#}${_left// /-}] ${_progress}%%"
}

# Start of the installation
printf "Please provide your password for the installation.\n"
sudo printf "Installation started. Please wait.\n"

# Install required packages while sudo is active
case ${OS_VERSION} in
   Darwin)
       git clone https://github.com/Homebrew/brew $HOME/.brew >> /dev/null 2>&1
       xcode-select --install >> /dev/null 2>&1
       brew install vim ctags cmake >> /dev/null 2>&1 #TODO test if usable w\o git
       _progress=20
       ProgressBar ${_progress} ${_end}
       ;;
   Ubuntu)
       sudo apt update >> /dev/null 2>&1
       sudo apt install plank gnome-tweak-tool git build-essential cmake vim python3-dev exuberant-ctags >> /dev/null 2>&1
       sudo apt remove gnome-shell-extension-ubuntu-dock >> /dev/null 2>&1
       _progress=20
       ProgressBar ${_progress} ${_end}
       ;;
   Debian)
      sudo apt update >> /dev/null 2>&1
      sudo apt install plank gnome-tweak-tool git build-essential cmake vim python3-dev exuberant-ctags >> /dev/null 2>&1
      _progress=20
      ProgressBar ${_progress} ${_end}
      #TODO: curl exesse.tar.xz to the current folder
      tar -xf exesse.tar.xz && mkdir -p ~/.themes/ && cp -r themes/* ~/.themes/
      mkdir -p ~/.icons/ && cp -r icons/* ~/.icons/
      mkdir ~/.local/share/plank/themes/ -p && cp -r plank/* ~/.local/share/plank/themes/
      #TODO: remove archive and icons, themes and plank
      #TODO: compile blyr
      ;;
   *)
      echo 'ERROR: OS is not supported. Exiting installer now.'
      exit 1
      ;;
esac

# Folders creation
rm $HOME/.oh-my-zsh >> /dev/null 2>&1
mkdir $HOME/.bin >> /dev/null 2>&1
mkdir $HOME/Applications >> /dev/null 2>&1

# Google Cloud SDK installation
curl https://sdk.cloud.google.com --output gcp_install.sh --silent
chmod +x gcp_install.sh && ./gcp_install.sh --disable-prompts --install-dir=$HOME/.bin >> /dev/null 2>&1
rm -f gcp_install.sh
_progress=35
ProgressBar ${_progress} ${_end}gl

# Oh-my-zsh and custom setting installation
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" >> /dev/null 2>&1
curl #TODO download 'radvan.zsh-theme' --output $HOME/.oh-my-zsh/themes/radvan.zsh-theme --silent
curl #TODO download '.zshrc' --output $HOME/.zshrc --silent
#TODO echo here google gcert options
echo 'exec zsh' > $HOME/.bashrc
_progress=45
ProgressBar ${_progress} ${_end}

# Create necessary folders for python.vim
rm -rf $HOME/.vim && rm -f $HOME/.vimrc
mkdir -p $HOME/.vim/indent
_progress=50
ProgressBar ${_progress} ${_end}

# Download config files for python.vim from GitHub
curl https://raw.githubusercontent.com/exesse/python.vim/master/python.vim --output $HOME/.vim/indent/python.vim --silent #TODO place intend in this repo
curl https://raw.githubusercontent.com/exesse/python.vim/master/vimrc --output $HOME/.vimrc --silent #TODO place intend in this repo
_progress=55
ProgressBar ${_progress} ${_end}

# Clone Vundle from GitHub
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim >> /dev/null 2>&1
_progress=60
ProgressBar ${_progress} ${_end}

# Install VIM plugins
vim +PluginInstall +qall >> /dev/null 2>&1
_progress=65
ProgressBar ${_progress} ${_end}

# Compile YouCompleteMe
python3 ~/.vim/bundle/YouCompleteMe/install.py --clang-completer >> /dev/null 2>&1
_progress=75
ProgressBar ${_progress} ${_end}

# Install Flake8
python3 -m pip install flake8 >> /dev/null 2>&1
_progress=85
ProgressBar ${_progress} ${_end}

# Set VIM as a default editor
echo 'set editing-mode vi' > ~/.inputrc
_progress=90
ProgressBar ${_progress} ${_end}

_progress=100
ProgressBar ${_progress} ${_end}

# Activete the themes
printf "\nInstallation successfully finished.\n"
echo "Start **gnome-tweak-tool** and select 'exesse*' in each respective category."
echo "Select the same theme for Plank. Add **Plank** to autostartup."
echo "In extensions set **blyr** to '10; 0.9; 1.00' for Activities + Panel."

exit 0