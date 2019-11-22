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
    echo -e "\t [f | full]"
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
                                    f | full)           profile="full"
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

cd "$HOME" || return 
system_type=$(uname -s)
if [[ $system_type == "Darwin" ]]; then
    if [ "$interactive" = "1" ]; then
        read -p "Is it Mac based your distribution? (y/N)" -n 1 -r
        echo
        if [[ "$REPLY" != ^[Yy]$ ]]; then
            echo "Exiting program."
            exit 1
        fi
    fi
    echo "Hello Mac User!"
    echo "Installing Homebrew..."
    # install homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    # install pkglist
    cat pkglist_mac.txt | grep -v "#" | xargs brew install

    # cask installs
    brew cask install docker
    brew cask install iterm2

    defaults write com.apple.dock workspaces-auto-swoosh -bool NO
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    git config --global core.excludesfile ~/.gitignore

elif [[ $system_type == "Linux" ]]; then 
    if [ "$interactive" = "1" ]; then
        read -p "Is it Linux based your distribution? (y/N)" -n 1 -r
        echo
        if [[ "$REPLY" != ^[Yy]$ ]]; then
            echo "Exiting program."
            exit 1
        fi
    fi
    # Variables
    dir=$PWD
    files="bashrc bash_aliases .fonts gitconfig gitignore i3 spacemacs tmux.conf vimrc zshrc"

    echo "Hello Linux User!"

    # Install basic environment tools
    sudo apt update && sudo apt-get install -y $(cat pkglist.txt | grep -v "#" | awk '{print $1}')
    if [[ $profile == "pentester" || $profile == "full" ]]; then
        sudo apt-get install -y $(cat pkglist_pentester.txt | grep -v "#" | awk '{print $1}')
    elif [[ $profile == "developer" || $profile == "full" ]]; then
        sudo apt-get install -y $(cat pkglist_developer.txt | grep -v "#" | awk '{print $1}')
    elif [[ $profile == "server" || $profile == "full" ]]; then
        sudo apt-get install -y $(cat pkglist_server.txt | grep -v "#" | awk '{print $1}')
    fi

    # Install VBox Additions
    # cd /tmp/
    # wget -q -c http://download.virtualbox.org/virtualbox/5.2.6/VBoxGuestAdditions_5.2.6.iso
    # sudo mkdir /media/VBoxGuestAdditions
    # sudo mount -o loop,ro /tmp/VBoxGuestAdditions_5.2.6.iso /media/VBoxGuestAdditions
    # sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run 
    # rm VBoxGuestAdditions_5.2.6.iso
    # sudo umount /media/VBoxGuestAdditions
    # sudo rm -rf /media/VBoxGuestAdditions

    # Install emacs26
    cd /tmp/
    wget http://ftp.rediris.es/mirror/GNU/emacs/emacs-26.1.tar.gz
    sudo tar xvf emacs-26.1.tar.gz -C /opt
    cd /opt/emacs-26.1/
    sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
    sudo apt-get update
    sudo apt-get build-dep -y emacs25
    sudo ./configure
    sudo make
    sudo make install 
    sudo chown -R $USER:$USER /opt/emacs-25.1
    
    ln -s $dir/spacemacs/src/.spacemacs ~/.spacemacs
    ln -s $dir/spacemacs/src/.emacs.d/ ~/.emacs.d
    ln -s $dir/spacemacs/docker/src/.org-capture-templates.el /home/$USER/.org-capture-templates.el

    if [[ $profile == "pentester" || $profile == "full" ]]; then
        # Install Radare2
        cd /tmp/
        git clone https://github.com/radareorg/radare2.git
        mv radare2 /opt/
        cd /opt/
        chown -R $USER:$USER radare2
        sudo radare2/sys/install.sh

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

    # Install fonts
    sudo fc-cache -fv

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