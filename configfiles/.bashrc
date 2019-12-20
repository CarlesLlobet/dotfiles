# Author: Carles Llobet

# Colors definition
BLACK="\[\033[0;30m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
DEFAULT_COLOR="\[\033[00m\]"
BLACK_BACKGROUND="\[\e[41;1m\]"

# History control
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL="ignoredups:erasedups"
# append to the history file, don't overwrite it
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export HISTFILESIZE=500000
export HISTSIZE=100000

# Shell Options
# multi-line commands as one command
shopt -s cmdhist
shopt -s autocd
set show-all-if-ambiguous on

# Prompt
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
if [ "$color_prompt" = yes ]; then
    #PS1="$DARK_GRAY[\t][\u@\h:$LIGHT_GRAY\w$DARK_GRAY]\$$DEFAULT_COLOR "
    PS1="\n\[$DARK_GRAY┌─[\t]──[\u@\H:$LIGHT_GRAY\w$DARK_GRAY]\n$DARK_GRAY└──\$$DEFAULT_COLOR "
else
    PS1="\n\[$DARK_GRAY┌─[\t]──[\u@\H:$LIGHT_GRAY\w$DARK_GRAY]\n$DARK_GRAY└──\$$DEFAULT_COLOR "
    #PS1="$DARK_GRAY[\t][\u@\h:$LIGHT_GRAY\w$DARK_GRAY]\$$DEFAULT_COLOR "
fi

unset color_prompt force_color_prompt

# Colors aliases
# enable color support of ls and also add handy color aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Functions
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd: Makes new Dir and jumps inside

# Exports 
VISUAL=editor; export VISUAL EDITOR=editor; export EDITOR
export MYVIMRC=~/.vimrc

if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    # This is for a docker-tools installation in windows to use with VBox Hipervisor
    # if you use docker with Windows Hiper-V and don't have VBox, use 127.0.0.1:2376
    export DOCKER_HOST=tcp://192.168.99.100:2376  # your Docker IP
    export DOCKER_CERT_PATH=/mnt/c/Users/${USER}/.docker/machine/certs
    export DOCKER_TLS_VERIFY=1
fi