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

    architecture=$(uname -m)
    if [[ $architecture == "arm64" ]]; then
        echo "Installing Rosetta"
        softwareupdate --install-rosetta

        echo "Installing Homebrew..."
        # install homebrew
        arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        # install pkglist
        cat $dotfilesdir/packages/pkglist_mac.txt | grep -v "#" | xargs arch -x86_64 brew install

        # Installing pip
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        python3 get-pip.py

        # cask installs
        arch -x86_64 brew cask install docker
        arch -x86_64 brew cask install iterm2

        defaults write com.apple.dock workspaces-auto-swoosh -bool NO
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

        git config --global core.excludesfile ~/.gitignore
    elif [[ $architecture == "x86_64" ]]; then
        echo "Installing Homebrew..."
        # install homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        # install pkglist
        cat $dotfilesdir/packages/pkglist.txt | grep -v "#" | xargs brew install

        # cask installs
        brew cask install docker
        brew cask install iterm2

        defaults write com.apple.dock workspaces-auto-swoosh -bool NO
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

        git config --global core.excludesfile ~/.gitignore
    else
        echo "This dotfiles just support arm64 or x86_64 MacOS architectures. Unrecognized $architecture distribution."
        exit 1
    fi

    configfiles="$(find $dotfilesdir/configfiles -maxdepth 1 -type f | awk -F/ '{print $NF}')"

    for file in $configfiles; do
        if [ -h ~/"$file" ]; then
            echo "Deleting existing symlink ~/.$file"
            unlink ~/"$file"
        elif [ -f ~/"$file" ]; then
            echo "Deleting existing file ~/.$file"
            rm -rf ~/"$file" 
        fi
        echo "Creating symlink to $file in ~"
        if [[ $file == ".bashrc" ]]; then
            ln -s $dotfilesdir/configfiles/.bashrc_mac ~/$file
        else
            ln -s $dotfilesdir/configfiles/$file ~/$file
        fi
    done

    # Spacemacs
    if [ -d $dotfilesdir/configfiles/spacemacs ]; then
        if [ -h ~/.spacemacs ]; then
                echo "Deleting existing symlink ~/.spacemacs"
                unlink ~/.spacemacs
        elif [ -f ~/.spacemacs ]; then
            echo "Deleting existing file ~/.spacemacs"
            rm -rf ~/.spacemacs
        fi

        ln -s $dotfilesdir/configfiles/spacemacs/src/.spacemacs ~/.spacemacs
        if [ -h ~/.emacs.d ]; then
                echo "Deleting existing symlink ~/.emacs.d"
                unlink ~/.emacs.d
        elif [ -f ~/.emacs.d ]; then
            echo "Deleting existing file ~/.emacs.d"
            rm -rf ~/.emacs.d
        fi
        ln -s $dotfilesdir/configfiles/spacemacs/src/.emacs.d/ ~/.emacs.d
        if [ -h ~/.org-capture-templates.el ]; then
                echo "Deleting existing symlink ~/.org-capture-templates.el"
                unlink ~/.org-capture-templates.el
        elif [ -f ~/.org-capture-templates.el ]; then
            echo "Deleting existing file ~/.org-capture-templates.el"
            rm -rf ~/.org-capture-templates.el
        fi
        ln -s $dotfilesdir/configfiles/spacemacs/docker/src/.org-capture-templates.el ~/.org-capture-templates.el
    fi

    # Load BashRC
    echo "Sourcing bashrc"
    if [ -h ~/.bashrc ]; then
        source ~/.bashrc
    fi

    # Ranger
    echo "Configuring ranger"
    if [ -h ~/.config/ranger ]; then
        echo "Deleting existing symlink ~/.config/ranger"
        unlink ~/.config/ranger
    elif [ -d ~/.config/ranger ]; then
        echo "Deleting ranger directory"
        rm -rf ~/.config/ranger
    fi
    if [ -d $dotfilesdir/configfiles/ranger ];then
        if [ -d ~/.config ]; then
            ln -s $dotfilesdir/configfiles/ranger ~/.config/
        else
            mkdir ~/.config
            ln -s $dotfilesdir/configfiles/ranger ~/.config/
        fi
    fi

    # Vim
    echo "Configuring vim"
    if [ -h ~/.vim ]; then
        echo "Deleting existing symlink ~/.vim"
        unlink ~/.vim
    elif [ -d ~/.vim ]; then
        echo "Deleting vim directory"
        rm -rf ~/.vim
    fi
    if [ -d $dotfilesdir/configfiles/.vim ];then
        ln -s $dotfilesdir/configfiles/.vim ~
    fi
elif [[ $system_type == "Linux" ]]; then
    echo "Hello Linux User!"

    ### Select APT repositories to add###
    echo "Adding APT repositories"

    distribution=$(cat /etc/*-release | grep DISTRIB_ID | awk -F= '{print $2}')

    
    if [ "$interactive" = "1" ]; then
        addedrepositories=$(cat $dotfilesdir/repositories/repos.txt | grep -v "#" | awk -F'\n' '{print $1 "|ON"}')
        if [[ $profile == "pentester" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'|'"$(cat $dotfilesdir/repositories/repos_pentester.txt | grep -v "#" | awk -F'\n' '{print $1 "|ON"}')"
        elif [[ $profile == "developer" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'|'"$(cat $dotfilesdir/repositories/repos_developer.txt | grep -v "#" | awk -F'\n' '{print $1 "|ON"}')"
        elif [[ $profile == "server" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'|'"$(cat $dotfilesdir/repositories/repos_server.txt | grep -v "#" | awk -F'\n' '{print $1 "|ON"}')"
        fi

        IFS=$'|'
        addedrepositoriesarray=($addedrepositories)
        IFS=$' \t\n'

        if [ ${#addedrepositoriesarray[@]} != 0 ]; then
        
            selectedrepositories=$(whiptail --title "Repositories selected for $profile profile" --separate-output --noitem --checklist "" 16 98 10 "${addedrepositoriesarray[@]}" 3>&1 1>&2 2>&3)

            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                echo "Installation canceled"
                exit
            fi
        fi
    else
        addedrepositories=$(cat $dotfilesdir/repositories/repos.txt | grep -v "#" | awk -F'\n' '{print $1}')
        if [[ $profile == "pentester" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'|'"$(cat $dotfilesdir/repositories/repos_pentester.txt | grep -v "#" | awk -F'\n' '{print $1}')"
        elif [[ $profile == "developer" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'|'"$(cat $dotfilesdir/repositories/repos_developer.txt | grep -v "#" | awk -F'\n' '{print $1}')"
        elif [[ $profile == "server" || $profile == "full" ]]; then
            addedrepositories=$addedrepositories$'|'"$(cat $dotfilesdir/repositories/repos_server.txt | grep -v "#" | awk -F'\n' '{print $1}')"
        fi
        IFS=$'|'
        selectedrepositories=($addedrepositories)
        IFS=$' \t\n'
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
            echo "$selectedrepositories"
            IFS=$'\n'
            for repo in $selectedrepositories; do
                url=$(echo "$repo" | tr ' ' '\n' | grep https)
                if grep -q "$url" "/etc/apt/sources.list"; then
                    echo "$repo already found in /etc/apt/sources.list"
                else
                    sudo bash -c "echo '$repo' >> /etc/apt/sources.list"
                fi
                IFS=$' \t\n'
            done
        else
            sudo apt-get install -y software-properties-common
            sudo add-apt-repository $selectedrepositories
        fi
    fi

    ### Select APT tools to install###
    echo "Installing APT tools"

    if [ "$interactive" = "1" ]; then

        installpackages=$(cat $dotfilesdir/packages/pkglist.txt | grep -v "#" | awk '{print $1 " ON"}')
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

        selectedpackages=$installpackages
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

        selectedscripts=$installscripts
    fi

    for script in $selectedscripts; do
        echo "Installing script $script"
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
        selectedconfigfiles=$configfiles
    fi

    for file in $selectedconfigfiles; do
        if [ -h ~/"$file" ]; then
            echo "Deleting existing symlink ~/.$file"
            unlink ~/"$file"
        elif [ -f ~/"$file" ]; then
            echo "Deleting existing file ~/.$file"
            rm -rf ~/"$file" 
        fi
        echo "Creating symlink to $file in ~"
        ln -s $dotfilesdir/configfiles/$file ~/$file
    done

    # Spacemacs
    if [ -d $dotfilesdir/configfiles/spacemacs ]; then
        if [ -h ~/.spacemacs ]; then
                echo "Deleting existing symlink ~/.spacemacs"
                unlink ~/.spacemacs
        elif [ -f ~/.spacemacs ]; then
            echo "Deleting existing file ~/.spacemacs"
            rm -rf ~/.spacemacs
        fi

        ln -s $dotfilesdir/configfiles/spacemacs/src/.spacemacs ~/.spacemacs
        if [ -h ~/.emacs.d ]; then
                echo "Deleting existing symlink ~/.emacs.d"
                unlink ~/.emacs.d
        elif [ -f ~/.emacs.d ]; then
            echo "Deleting existing file ~/.emacs.d"
            rm -rf ~/.emacs.d
        fi
        ln -s $dotfilesdir/configfiles/spacemacs/src/.emacs.d/ ~/.emacs.d
        if [ -h ~/.org-capture-templates.el ]; then
                echo "Deleting existing symlink ~/.org-capture-templates.el"
                unlink ~/.org-capture-templates.el
        elif [ -f ~/.org-capture-templates.el ]; then
            echo "Deleting existing file ~/.org-capture-templates.el"
            rm -rf ~/.org-capture-templates.el
        fi
        ln -s $dotfilesdir/configfiles/spacemacs/docker/src/.org-capture-templates.el ~/.org-capture-templates.el
    fi

    # Load BashRC
    echo "Sourcing bashrc"
    if [ -h ~/.bashrc ]; then
        source ~/.bashrc
    fi

    # Ranger
    echo "Configuring ranger"
    if [ -h ~/.config/ranger ]; then
        echo "Deleting existing symlink ~/.config/ranger"
        unlink ~/.config/ranger
    elif [ -d ~/.config/ranger ]; then
        echo "Deleting ranger directory"
        rm -rf ~/.config/ranger
    fi
    if [ -d $dotfilesdir/configfiles/ranger ];then
        if [ -d ~/.config ]; then
            ln -s $dotfilesdir/configfiles/ranger ~/.config/
        else
            mkdir ~/.config
            ln -s $dotfilesdir/configfiles/ranger ~/.config/
        fi
    fi

    # Vim
    echo "Configuring vim"
    if [ -h ~/.vim ]; then
        echo "Deleting existing symlink ~/.vim"
        unlink ~/.vim
    elif [ -d ~/.vim ]; then
        echo "Deleting vim directory"
        rm -rf ~/.vim
    fi
    if [ -d $dotfilesdir/configfiles/.vim ];then
        ln -s $dotfilesdir/configfiles/.vim ~
    fi

    # If WSL set symlink to Windows Home
    if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        echo "WSL Detected!"
        if [ -h ~/Windows ]; then
            unlink ~/Windows
        fi
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