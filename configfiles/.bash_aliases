alias r='ranger'
alias python='python3'
alias pip='pip3'
alias d2j='d2j-dex2jar'
alias dos2unixall='find . -type f -print0 | xargs -0 dos2unix'
alias dockerip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dockerupdate='docker-compose pull && docker-compose up -d'
alias jdgui='java -jar /Applications/JD-GUI.app/Contents/Resources/Java/jd-gui-1.6.6-min.jar'

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

## Proxmox
alias gpuenable="sed -i 's/^softdep/#softdep/g' /etc/modprobe.d/vfio.conf && sed -i 's/a804,1002/a804 #,1002/g' /etc/modprobe.d/vfio.conf && pct mount 107 && sed -i 's/#hwaccel/hwaccel/g' /var/lib/lxc/107/rootfs/root/config/config.yaml && pct unmount 107 && shutdown -r now"
alias gpuinit="sed -i 's/hostpci0/#hostpci0/g' /etc/pve/qemu-server/100.conf && sed -i 's/hostpci1/#hostpci1/g' /etc/pve/qemu-server/100.conf && sed -i 's/vga/#vga/g' /etc/pve/qemu-server/100.conf && modprobe amdgpu && pct set 107 --dev1 path=/dev/dri/renderD128,mode=0666 && pct set 119 --dev0 path=/dev/dri/renderD128,mode=0666 && pct start 107 && pct start 119"
# TODO: Add this to gpuinit: pct set 107 --dev0 path=/dev/bus/usb/$(lsusb | grep Google | cut -d" " -f2,4 | cut -d":" -f1 | sed 's/ /\//g'),mode=0666
alias gpudisable="sed -i 's/#hostpci0/hostpci0/g' /etc/pve/qemu-server/100.conf && sed -i 's/#hostpci1/hostpci1/g' /etc/pve/qemu-server/100.conf && sed -i 's/#vga/vga/g' /etc/pve/qemu-server/100.conf && sed -i 's/ #//g' /etc/modprobe.d/vfio.conf && sed -i 's/^#//g' /etc/modprobe.d/vfio.conf && pct mount 107 && sed -i 's/hwaccel/#hwaccel/g' /var/lib/lxc/107/rootfs/root/config/config.yaml && pct unmount 107 && pct set 107 -del dev1 && pct set 119 -del dev0 && shutdown -r now"
