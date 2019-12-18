#!/bin/bash

######### Constants #########
profile=b
interactive=1
dotfilesdir=$PWD
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
    cat $dotfilesdir/packages/pkglist_mac.txt | grep -v "#" | xargs brew install

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

    echo "Hello Linux User!"

    ### Install APT basic tools ###
    echo "Installing APT basic tools"

    sudo apt update && sudo apt-get install -y $(cat $dotfilesdir/packages/pkglist.txt | grep -v "#" | awk '{print $1}')

    ### Install APT profile specific tools ###
    echo "Installing APT $profile specific tools"
    if [[ $profile == "pentester" || $profile == "full" ]]; then
        sudo apt-get install -y $(cat $dotfilesdir/packages/pkglist_pentester.txt | grep -v "#" | awk '{print $1}')
    elif [[ $profile == "developer" || $profile == "full" ]]; then
        sudo apt-get install -y $(cat $dotfilesdir/packages/pkglist_developer.txt | grep -v "#" | awk '{print $1}')
    elif [[ $profile == "server" || $profile == "full" ]]; then
        sudo apt-get install -y $(cat $dotfilesdir/packages/pkglist_server.txt | grep -v "#" | awk '{print $1}')
    fi

    ### Install Manual tools ###
    echo "Installing Manual tools from installscripts of $profile profile"
    if [[ $profile == "full" ]]; then
        installscripts="$(find $dotfilesdir/installscripts -maxdepth 2 -type f | awk -F/ '{print $(NF-1)"/"$NF}')"
    else
        installscripts="$(find $dotfilesdir/installscripts/basic -maxdepth 1 -type f | awk -F/ '{print $(NF-1)"/"$NF}')"
        installscripts=$installscripts$'\n'"$(find $dotfilesdir/installscripts/$profile -maxdepth 1 -type f | awk -F/ '{print $(NF-1)"/"$NF}')"
    fi

    for script in $installscripts; do
        if [[ "$(echo $script | awk -F/ '{print $NF}')" == "requirements.txt" ]]; then
            pip install -r "$dotfilesdir/installscripts/$script"
        else
            source "$dotfilesdir/installscripts/$script"
        fi
    done
    
    # BurpSuite TODO: Install from own version

    # synthesis
    # john the ripper
    # sage
    # hashcat
    # dotNetInspector
    # dotpeek <- only works on windows
    # dex2jar
    # kali

    ### Configfiles Symlinks ###
    echo "### Configurating environment with configfiles ###"

    configfiles="$(find $dotfilesdir/configfiles -maxdepth 1 -type f | awk -F/ '{print $NF}')"
    
    for file in $configfiles; do
        if [ -h ~/.$file ]; then
            echo "Deleting existing symlink ~/.$file"
            unlink ~/.$file
        elif [ -f ~/.$file ]; then
            echo "Deleting existing file ~/.$file"
            rm -rf ~/.$file 
        fi
        echo "Creating symlink to $file in ~"
        ln -s $dotfilesdir/configfiles/$file ~/.$file
    done

    # Spacemacs
    ln -s $dir/spacemacs/src/.spacemacs ~/.spacemacs
    ln -s $dir/spacemacs/src/.emacs.d/ ~/.emacs.d
    ln -s $dir/spacemacs/docker/src/.org-capture-templates.el /home/$USER/.org-capture-templates.el

    # Install fonts
    echo "Installing fonts"
    sudo fc-cache -fv

    # Load BashRC
    echo "Sourcing bashrc"
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    fi

    # i3
    echo "Configuring i3"
    if [ -e ~/i3 ]; then
        echo "Deleting i3 directory"
        rm -rf ~/i3
    fi
    ln -s $dotfilesdir/configfiles/i3 ~/

    # Ranger
    echo "Configuring ranger"
    if [ -e ~/.config/ranger ]; then
        echo "Deleting ranger directory"
        rm -rf ~/.config/ranger
    fi
    ln -s $dotfilesdir/configfiles/ranger ~/.config/

    # Theme for oh-my-zsh
    echo "Configuring oh-my-zsh theme"
    if [ -e ~/.oh-my-zsh ]; then
        ln -s $dotfilesdir/configfiles/zsh-theme ~/.oh-my-zsh/themes/
    fi

    # Configure language
    #echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen \
    #    && locale-gen es_ES.UTF.8 \
    #    && dpkg-reconfigure locales \
    #    && /usr/sbin/update-locale LANG=es_ES.UTF-8
else
    echo "This dotfiles just support Linux and MacOS distributions. Unrecognized $system_type distribution."
    exit 1
fi