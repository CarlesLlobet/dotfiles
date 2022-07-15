alias r='ranger'
alias python='python3'
alias pip='pip3'
alias d2j='d2j-dex2jar'
alias dos2unixall='find . -type f -print0 | xargs -0 dos2unix'
alias dockerip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'

alias cp='cp -iv'                           # 'cp' that doesnt overwrite without asking
alias mv='mv -iv'                           # 'mv' that doesnt overwrite without asking
alias mkdir='mkdir -pv'                     # 'mkdir' that autocreates needed parents
alias la='ls -la'                           # 'la'

alias up='cd ../'                           # Go back 1 directory level (for fast typers)
alias upp='cd ../../'                       # Go back 2 directory levels
alias uppp='cd ../../../'                   # Go back 3 directory levels
alias upppp='cd ../../../../'               # Go back 4 directory levels
alias uppppp='cd ../../../../../'           # Go back 5 directory levels
alias upppppp='cd ../../../../../../'       # Go back 6 directory levels

alias qfind="find . -iname "
alias plutil="plistutil"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
#alias vkill='kill $(ps aux|grep firefox|grep opt|grep -Eow [0-9]{5})'
#alias vlc='vlc --control dbus'
#alias v='vim --remote-silent'
#alias tmux="TERM=screen-256color-bce tmux"
#alias tmux="tmux -2 attach"
