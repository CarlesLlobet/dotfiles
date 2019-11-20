#!/bin/bash

# variables
dir=$PWD
files="bashrc tmux.conf bash_aliases fonts i3 ranger zshrc vimrc spacemacs"

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

# Ranger
if [ -e ~/.config/ranger ]; then
    echo "Deleting ranger directory"
    rm -rf ~/.config/ranger
fi
ln -s $dir/ranger ~/.config/

# Theme for oh-my-zsh
if [ -e ~/.oh-my-zsh ]; then
    ln -s $dir/krowone.zsh-theme ~/.oh-my-zsh/themes/
fi
