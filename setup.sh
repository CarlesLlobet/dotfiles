#!/bin/bash

######### Constants #########
profile="basic"
interactive=1
dotfilesdir=$PWD
######### Functions #########

usage()
{
    echo -e "Usage: setup.sh [-h | --help] [-y | --yes] [-p | --profile <profile>]"
    echo -e "Profiles:"
    echo -e "\t [b | basic] (default)"
    echo -e "\t [f | full]"
    echo -e "\t [d | developer]"
    echo -e "\t [p | pentester]"
    echo -e "\t [s | server]"
    
}

######### Main #########
while [ "$1" != "" ]; do
    case $1 in
        -y | --yes )            interactive=0
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
        if [[ ! "$REPLY" =~ ^[y|Y]$ ]]; then
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
    echo "Hello Linux User!"

    ### Select APT repositories to add###
    echo "Adding APT repositories"

    distribution=$(cat /etc/*-release | grep DISTRIB_ID | awk -F= '{print $2}')

    
    if [ "$interactive" = "1" ]; then
        addedrepositories=$(cat $dotfilesdir/repositories/repos.txt | grep -v "#" | awk '{print $1 " ON"}')
        if [[ $profile == "pentester" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'\n'"$(cat $dotfilesdir/repositories/repos_pentester.txt | grep -v "#" | awk '{print $1 " ON"}')"
        elif [[ $profile == "developer" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'\n'"$(cat $dotfilesdir/repositories/repos_developer.txt | grep -v "#" | awk '{print $1 " ON"}')"
        elif [[ $profile == "server" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'\n'"$(cat $dotfilesdir/repositories/repos_server.txt | grep -v "#" | awk '{print $1 " ON"}')"
        fi

        addedrepositoriesarray=($addedrepositories)

        if [ ${#addedrepositoriesarray[@]} != 0 ]; then
        
            selectedrepositories=$(whiptail --title "Repositories selected for $profile profile" --separate-output --noitem --checklist "" 16 48 10 "${addedrepositoriesarray[@]}" 3>&1 1>&2 2>&3)

            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                echo "Installation canceled"
                exit
            fi
        fi
    else
        addedrepositories=$(cat $dotfilesdir/repositories/pkglist.txt | grep -v "#" | awk '{print $1}')
        if [[ $profile == "pentester" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'\n'"$(cat $dotfilesdir/repositories/repos_pentester.txt | grep -v "#" | awk '{print $1}')"
        elif [[ $profile == "developer" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'\n'"$(cat $dotfilesdir/repositories/repos_developer.txt | grep -v "#" | awk '{print $1}')"
        elif [[ $profile == "server" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'\n'"$(cat $dotfilesdir/repositories/repos_server.txt | grep -v "#" | awk '{print $1}')"
        fi

        selectedrepositories=($addedrepositories)
    fi

    if [ "$selectedrepositories" != "" ]; then
        if [ "$distribution" == "Kali" ]; then
            echo "WARNING: Editing sources.list directly in Kali Linux may break system due its fragility!"
            if [ "$interactive" = "1" ]; then
                read -p "Do you want to continue? (y/N)" -n 1 -r
                echo
                if [[ ! "$REPLY" =~ ^[y|Y]$ ]]; then
                    echo "Exiting program."
                    exit 1
                fi
            fi
            for repo in $selectedrepositories; do
                sudo bash -c "echo '$repo' >> /etc/apt/sources.list"
            done
        else
            sudo apt-get install -y software-properties-common
            sudo add-apt-repository $selectedrepositories
        fi
    fi
    

    ### Select APT tools to install###
    echo "Installing APT tools"

    if [ "$interactive" = "1" ]; then

        installpackages=$(cat $dotfilesdir/packages/pkglist.txt | grep -v "#" | awk '{print $1 " ON"}')$'\n'
        if [[ $profile == "pentester" || $profile == "full" ]]; then
            installpackages=$installpackages$'\n'"$(cat $dotfilesdir/packages/pkglist_pentester.txt | grep -v "#" | awk '{print $1 " ON"}')"
        elif [[ $profile == "developer" || $profile == "full" ]]; then
            installpackages=$installpackages$'\n'"$(cat $dotfilesdir/packages/pkglist_developer.txt | grep -v "#" | awk '{print $1 " ON"}')"
        elif [[ $profile == "server" || $profile == "full" ]]; then
            installpackages=$installpackages$'\n'"$(cat $dotfilesdir/packages/pkglist_server.txt | grep -v "#" | awk '{print $1 " ON"}')"
        fi

        installpackagesarray=($installpackages)

        if [ ${#installpackagesarray[@]} != 0 ]; then
        
            selectedpackages=$(whiptail --title "Packages selected for $profile profile" --separate-output --noitem --checklist "" 16 48 10 "${installpackagesarray[@]}" 3>&1 1>&2 2>&3)

            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                echo "Installation canceled"
                exit
            fi
        fi
    else
        installpackages=$(cat $dotfilesdir/packages/pkglist.txt | grep -v "#" | awk '{print $1}')
        if [[ $profile == "pentester" || $profile == "full" ]]; then
            installpackages=$installpackages$'\n'"$(cat $dotfilesdir/packages/pkglist_pentester.txt | grep -v "#" | awk '{print $1}')"
        elif [[ $profile == "developer" || $profile == "full" ]]; then
            installpackages=$installpackages$'\n'"$(cat $dotfilesdir/packages/pkglist_developer.txt | grep -v "#" | awk '{print $1}')"
        elif [[ $profile == "server" || $profile == "full" ]]; then
            installpackages=$installpackages$'\n'"$(cat $dotfilesdir/packages/pkglist_server.txt | grep -v "#" | awk '{print $1}')"
        fi

        selectedpackages=($installpackages)
    fi

    sudo apt update && sudo apt-get install -y $selectedpackages

    ### Install Manual tools ###
    echo "Installing Manual tools from installscripts of $profile profile"

    if [ "$interactive" = "1" ]; then

        if [[ $profile == "full" ]]; then
            installscripts="$(find $dotfilesdir/installscripts -maxdepth 2 -type f | awk -F/ '{print $(NF-1)"/"$NF" ON"}')"
        else
            installscripts="$(find $dotfilesdir/installscripts/basic -maxdepth 1 -type f | awk -F/ '{print $(NF-1)"/"$NF" ON"}')"
            if [[ $profile != "basic" ]]; then
                installscripts=$installscripts$'\n'"$(find $dotfilesdir/installscripts/$profile -maxdepth 1 -type f | awk -F/ '{print $(NF-1)"/"$NF" ON"}')"
            fi
        fi

        installscriptsarray=($installscripts)

        if [ ${#installscriptsarray[@]} != 0 ]; then
        
            selectedscripts=$(whiptail --title "Install scripts selected for $profile profile" --separate-output --noitem --checklist "" 16 58 10 "${installscriptsarray[@]}" 3>&1 1>&2 2>&3)

            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                echo "Installation canceled"
                exit
            fi
        fi
    else
        if [[ $profile == "full" ]]; then
            installscripts="$(find $dotfilesdir/installscripts -maxdepth 2 -type f | awk -F/ '{print $(NF-1)"/"$NF}')"
        else
            installscripts="$(find $dotfilesdir/installscripts/basic -maxdepth 1 -type f | awk -F/ '{print $(NF-1)"/"$NF}')"
            if [[ $profile != "basic" ]]; then
                installscripts=$installscripts$'\n'"$(find $dotfilesdir/installscripts/$profile -maxdepth 1 -type f | awk -F/ '{print $(NF-1)"/"$NF}')"
            fi
        fi

        selectedscripts=($installscripts)
    fi

    for script in $selectedscripts; do
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

    if [ "$interactive" = "1" ]; then

        configfiles="$(find $dotfilesdir/configfiles -maxdepth 1 -type f | awk -F/ '{print $NF" ON"}')"
        configfilesarray=($configfiles)

        if [ ${#configfilesarray[@]} != 0 ]; then

            selectedconfigfiles=$(whiptail --title "Configuration files to load" --separate-output --noitem --checklist "" 16 38 10 "${configfilesarray[@]}" 3>&1 1>&2 2>&3)

            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                echo "Installation canceled"
                exit
            fi
        fi
    else
        configfiles="$(find $dotfilesdir/configfiles -maxdepth 1 -type f | awk -F/ '{print $NF}')"
        selectedconfigfiles=($configfiles)
    fi
    
    for file in $selectedconfigfiles; do
        if [ -h ~/$file ]; then
            echo "Deleting existing symlink ~/.$file"
            unlink ~/$file
        elif [ -f ~/$file ]; then
            echo "Deleting existing file ~/.$file"
            rm -rf ~/$file 
        fi
        echo "Creating symlink to $file in ~"
        ln -s $dotfilesdir/configfiles/$file ~/$file
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
    if [ -h ~/.bashrc ]; then
        source ~/.bashrc
    fi

    # Ranger
    echo "Configuring ranger"
    if [ -e ~/.config/ranger ]; then
        echo "Deleting ranger directory"
        rm -rf ~/.config/ranger
    fi
    if [ -e $dotfilesdir/configfiles/ranger ];then
        ln -s $dotfilesdir/configfiles/ranger ~/.config/
    fi

    # If WSL set symlink to Windows Home
    if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        echo "WSL Detected!"
        ln -s /mnt/c/Users/${USER} ~/Windows
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