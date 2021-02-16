#!/bin/bash

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

# Identify working environment
OS_VERSION=$(uname -v)
_progress=0
_end=100
_install_dir=/tmp/boxes.setup

# Check current OS and make sure it is supported
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

# Start of the installation
printf "Please provide your password for the installation.\n"
sudo printf "Installation started. Please wait.\n"

# Create temporary install folder
mkdir -p ${_install_dir} && cd ${_install_dir}

# Install required packages while sudo is active
case ${OS_VERSION} in
   Darwin)
       git clone https://github.com/Homebrew/brew $HOME/.brew #>> /dev/null 2>&1
       xcode-select --install #>> /dev/null 2>&1
       brew install vim ctags cmake #>> /dev/null 2>&1
       _progress=20
       ProgressBar ${_progress} ${_end}
       ;;
   Ubuntu)
       sudo apt update #>> /dev/null 2>&1
       sudo apt install plank gnome-tweak-tool git build-essential cmake vim python3-dev exuberant-ctags #>> /dev/null 2>&1
       sudo apt remove gnome-shell-extension-ubuntu-dock #>> /dev/null 2>&1
       _progress=20
       ProgressBar ${_progress} ${_end}
       curl https://github.com/exesse/boxes.setup/raw/main/files/exesse.tar.xz --output ${_install_dir}/exesse.tar.xz --silent
	   tar -xf ${_install_dir}/exesse.tar.xz && mkdir -p ~/.themes/ && cp -r ${_install_dir}/themes/* ~/.themes/
	   mkdir -p ~/.icons/ && cp -r ${_install_dir}/icons/* ~/.icons/
	   mkdir ~/.local/share/plank/themes/ -p && cp -r ${_install_dir}/plank/* ~/.local/share/plank/themes/
       _progress=30
       ProgressBar ${_progress} ${_end}
	   git clone https://github.com/yozoon/gnome-shell-extension-blyr.git $HOME/.bin/gnome-shell-extension-blyr
       cd $HOME/.bin/gnome-shell-extension-blyr/ && make local-install #>> /dev/null 2>&1
	   ;;
   Debian)
       sudo apt update #>> /dev/null 2>&1
       sudo apt install plank gnome-tweak-tool git build-essential cmake vim python3-dev exuberant-ctags #>> /dev/null 2>&1
       _progress=20
       ProgressBar ${_progress} ${_end}
	   curl https://github.com/exesse/boxes.setup/raw/main/files/exesse.tar.xz --output ${_install_dir}/exesse.tar.xz --silent
	   tar -xf ${_install_dir}/exesse.tar.xz && mkdir -p ~/.themes/ && cp -r ${_install_dir}/themes/* ~/.themes/
	   mkdir -p ~/.icons/ && cp -r ${_install_dir}/icons/* ~/.icons/
	   mkdir ~/.local/share/plank/themes/ -p && cp -r ${_install_dir}/plank/* ~/.local/share/plank/themes/
       _progress=30
       ProgressBar ${_progress} ${_end}
	   git clone https://github.com/yozoon/gnome-shell-extension-blyr.git $HOME/.bin/gnome-shell-extension-blyr
       cd $HOME/.bin/gnome-shell-extension-blyr/ && make local-install #>> /dev/null 2>&1
       ;;
   *)
      echo 'ERROR: OS is not supported. Exiting installer now.'
      exit 1
      ;;
esac

# Return to the workdir
cd ${_install_dir}

# Folders creation
rm $HOME/.oh-my-zsh #>> /dev/null 2>&1
mkdir $HOME/.bin #>> /dev/null 2>&1
mkdir $HOME/Applications #>> /dev/null 2>&1

# Google Cloud SDK installation
curl https://sdk.cloud.google.com --output ${_install_dir}/gcp_install.sh --silent
chmod +x ${_install_dir}/gcp_install.sh && bash ${_install_dir}/gcp_install.sh --disable-prompts --install-dir=$HOME/.bin #>> /dev/null 2>&1
_progress=45
ProgressBar ${_progress} ${_end}

# Oh-my-zsh and custom setting installation
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" #>> /dev/null 2>&1
curl https://github.com/exesse/boxes.setup/raw/main/files/radvan.zsh-theme --output $HOME/.oh-my-zsh/themes/radvan.zsh-theme --silent
curl https://github.com/exesse/boxes.setup/raw/main/files/zshrc --output $HOME/.zshrc --silent
echo 'exec zsh' > $HOME/.bashrc
_progress=52
ProgressBar ${_progress} ${_end}

# Create necessary folders for python.vim
rm -rf $HOME/.vim && rm -f $HOME/.vimrc
mkdir -p $HOME/.vim/indent
_progress=55
ProgressBar ${_progress} ${_end}

# Download config files for python.vim from GitHub
curl https://github.com/exesse/boxes.setup/raw/main/files/python.vim --output $HOME/.vim/indent/python.vim --silent
curl https://github.com/exesse/boxes.setup/raw/main/files/vimrc --output $HOME/.vimrc --silent 
_progress=60
ProgressBar ${_progress} ${_end}

# Clone Vundle from GitHub
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim #>> /dev/null 2>&1
_progress=65
ProgressBar ${_progress} ${_end}

# Install VIM plugins
vim +PluginInstall +qall #>> /dev/null 2>&1
_progress=75
ProgressBar ${_progress} ${_end}

# Compile YouCompleteMe
python3 ~/.vim/bundle/YouCompleteMe/install.py --clang-completer #>> /dev/null 2>&1
_progress=80
ProgressBar ${_progress} ${_end}

# Install Flake8
python3 -m pip install flake8 #>> /dev/null 2>&1
_progress=85
ProgressBar ${_progress} ${_end}

# Set VIM as a default editor
echo 'set editing-mode vi' > ~/.inputrc
_progress=90
ProgressBar ${_progress} ${_end}

# Perform cleanup after the installation
cd $HOME && rm -rf ${_install_dir}
_progress=95
ProgressBar ${_progress} ${_end}

# Activate the themes
_progress=100
ProgressBar ${_progress} ${_end}

printf "\nInstallation successfully finished.\n"
echo "Start **gnome-tweak-tool** and select 'exesse*' in each respective category."
echo "Select the same theme for Plank. Add **Plank** to autostartup."
echo "In extensions set **blyr** to '10; 0.9; 1.00' for Activities + Panel."
exit 0