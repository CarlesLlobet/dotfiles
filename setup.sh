#!/bin/bash

######### Constants #########
profile=b
interactive=1

######### Functions #########

usage()
{
    echo -e "Usage: setup.sh [-h | --help] [-y | --yes] [-p | --profile <profile>]"
    echo -e "Profiles:"
    echo -e "\t [b | basic] (default)"
    echo -e "\t [p | pentester]"
    echo -e "\t [d | developer]"
    echo -e "\t [s | server]"
}

######### Main #########
while [ "$1" != "" ]; do
    case $1 in
        -y | --yes )          interactive=0
                                ;;
        -p | --profile )        shift
                                case $1 in
                                    b | basic)          profile="basic"
                                                        ;;
                                    p | pentester)      profile="pentester"
                                                        ;;
                                    d | developer)      profile="developer"
                                                        ;;
                                    s | server)         profile="server"
                                                        ;;
                                    * )                 echo "Error: Selected profile not valid!"
                                                        echo "Exiting program."
                                                        exit 1
                                esac
                                level=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     echo "Error: $1 is not a valid setup command"
                                usage
                                exit 1
    esac
    shift
done

if [ "$interactive" = "1" ]; then
    read -p "Do you want to configure $profile profile? (y/N)" -n 1 -r
    echo
    if [[ ! "$REPLY" =~ ^[y|Y]$ ]]; then
        echo "Exiting program."
        exit 1
    fi
fi
echo "Configuring $profile profile"
exit
cd "$HOME" || return 
system_type=$(uname -s)
if [[ $system_type == "Darwin" ]]; then
    echo "Hello Mac User!"
    if [ "$interactive" = "1" ]; then
        read -p "Do you want to install Homebrew? (y/N)" -n 1 -r
        echo
        if [[ "$REPLY" != ^[Yy]$ ]]; then
            echo "Exiting program."
            exit 1
        fi
    fi
    echo "Installing Homebrew..."
    # install homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    # install the git from homebrew
    brew install git
    # fix that zsh nonsense
    brew install bash
    brew install git
    brew install byobu
    brew install neovim
      
    brew install python
    pip install --upgrade setuptools
    pip install --upgrade pip
    brew install yarn
    brew install golang
    brew install direnv

    brew cask install docker
    brew cask install iterm2
    brew install bash-completion

    defaults write com.apple.dock workspaces-auto-swoosh -bool NO
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    git config --global core.excludesfile ~/.gitignore

elif [[ $system_type == "Linux" ]]; then 
    # Variables
    dir=$PWD
    files="bashrc bash_aliases fonts i3 spacemacs tmux.conf vimrc zshrc"

    echo "Hello Linux User!"

    # Install environment tools
    sudo apt update && sudo apt-get install -y $(cat pkglist.txt | grep -v "#" | awk '{print $1}')

    # create symlinks
    for file in $files; do
        if [ -h ~/.$file ]; then
            echo "Deleting existing symlink ~/.$file"
            unlink ~/.$file
        elif [ -f ~/.$file ]; then
            echo "Deleting existing file ~/.$file"
            rm -rf ~/.$file 
        fi
        echo "Creating symlink to $file in ~"
        ln -s $dir/$file ~/.$file
    done

    # Load BashRC
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    fi
    # Ranger
    if [ -e ~/.config/ranger ]; then
        echo "Deleting ranger directory"
        rm -rf ~/.config/ranger
    fi
    ln -s $dir/ranger ~/.config/

    # Theme for oh-my-zsh
    if [ -e ~/.oh-my-zsh ]; then
        ln -s $dir/zsh-theme ~/.oh-my-zsh/themes/
    fi
fi