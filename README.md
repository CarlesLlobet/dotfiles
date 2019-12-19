# dotfiles
Environment configuration Run&Go

This project aims to avoid cumbersome configurations when working in a new environment.

## Getting Started

These instructions will get you a copy of the environment configuration up and running on your local machine. 

### Installation

```
git clone https://github.com/CarlesLlobet/dotfiles.git
```

### Usage

To apply this configurations you'll just need one of the following systems: 
- MacOSX
- Linux

You can configure the basic profile by executing:

```
sudo setup.sh
```

Select specific profiles or silent mode with parameters:

```
Usage: setup.sh [-h | --help] [-y | --yes] [-p | --profile <profile>]
        Profiles:
            [b | basic] (default)
            [f | full]
            [d | developer]
            [p | pentester]
            [s | server]
            
```

### Customization

To customize this dotfiles with your own tools, you just have to add/remove APT packages in the packagelists of each profile, and/or copy installscripts for manual installation/building of tools into the proper installscripts profile folder.

## Out of the Box Software

### Setup Packages
This specific package is always installed from the setup script in order to add repositories easily (if not in Kali distribution).

* [software-properties-common](https://packages.debian.org/sid/admin/software-properties-common) - Useful to add and remove PPAs (repositories) to apt

### Basic
Basic packages needed in any environment.

###### APT Packages

* [apt-transport-https](https://manpages.ubuntu.com/manpages/bionic/man1/apt-transport-https.1.html) - To download from APT via HTTPS
* [build-essential](https://packages.debian.org/es/sid/build-essential) - C and C++ compilers, with libc and dpkg-dev, make, etc.
* [ca-certificates](https://packages.debian.org/sid/ca-certificates) - To use CA Certificates
* [curl](https://curl.haxx.se/) - To make requests from command line
* [default-jre](https://packages.debian.org/stretch/default-jre) - Java Runtime Environment for Java based applications
* [direnv](https://direnv.net/) - Loads different ENV variables depending on the PWD automatically
* [git](https://git-scm.com/) - The only VCS that really matters
* [gnupg2](https://gnupg.org/) - OpenPGP implementation to cypher and decypher
* [gnutls-bin](https://www.gnutls.org/) - TLS SSL and DTLS to do secure communications
* [guake](http://guake-project.org/) - Top-down terminal for Gnome
* [htop](https://linux.die.net/man/1/htop) - Interactive Process Viewer
* [java-common](https://packages.debian.org/es/jessie/java-common) - Java Commons info
* [libpoppler-glib-dev](https://packages.debian.org/jessie/libpoppler-glib-dev) - To render PDF from console
* [libssl-dev](https://packages.debian.org/es/jessie/libssl-dev) - Dependency for OpenSSL
* [nvim](https://neovim.io/) - Vim based editor with extended features
* [python-pygments](https://pygments.org/) - Python syntax highlighter
* [python3-dev](https://packages.debian.org/buster/python3-dev) - Development libs for Python3
* [python3-pip](https://pypi.org/project/pip/) - Package Installer for Python
* [ranger](https://github.com/ranger/ranger) - Filemanager from Console, inspired in Vim
* [scrot](https://packages.debian.org/jessie/scrot) - SCReen shOT utility from command line
* [tar](https://linux.die.net/man/1/tar) - GZip / BZip2 / XZ Compression utility
* [thefuck](https://github.com/nvbn/thefuck) - Command line Typo Autocorrector
* [tmux](https://github.com/tmux/tmux/wiki) - Terminal Multiplexer
* [unrar](https://packages.debian.org/stretch/unrar) - RAR Compression utility
* [unzip](https://linux.die.net/man/1/unzip) - ZIP Compression utility
* [vim](https://www.vim.org/) - The Text Editor
* [xclip](https://linux.die.net/man/1/xclip) - Copy/Paste from Command line
* [zsh](http://zsh.sourceforge.net/) - Z shell

###### Scripted installation software

* [Docker](https://www.docker.com/) - Application virtualization software
* [Emacs](https://www.gnu.org/software/emacs/) - GUI Text Editor
* [VirtualBox GuestAdditions](https://docs.oracle.com/cd/E36500_01/E36502/html/qs-guest-additions.html) - Device Drivers and System applications to improve interaction between Host-VM

###### Pip packages

* N/A

### Developer
Specific packages for developers.

###### APT Packages

* [autotools-dev](https://developer.fedoraproject.org/tech/languages/c/autotools.html) - Required by automake (below)
* [automake](https://www.gnu.org/software/automake/) - To generate Makefiles regardless of the environment (Linux dist, installed packages,...)
* [cscope](http://cscope.sourceforge.net/) - Browse C Source Code (even C++ and Java)
* [exuberant-ctags](http://ctags.sourceforge.net/) - Multilanguage implementation of Ctags to identify functions
* [libc6-dev](https://packages.debian.org/jessie/libc6-dev) - GNU C development library
* [pandoc](https://pandoc.org/) - Converting Markup files to other formats (docx, ppt, etc.)

###### Scripted installation software

* N/A

###### Pip packages

* N/A
 
### Pentester
Specific packages for cybersecurity engineers.

###### APT Packages

* [binwalk](https://github.com/ReFirmLabs/binwalk) - RE tool to analyze and extract firmware images
* [cscope](http://cscope.sourceforge.net/) - Browse C Source Code (even C++ and Java)
* [exuberant-ctags](http://ctags.sourceforge.net/) - Multilanguage implementation of Ctags to identify functions
* [nmap](https://nmap.org/) - Network Discovery Scanner
* [pandoc](https://pandoc.org/) - Converting Markup files to other formats (docx, ppt, etc.)
* [qemu-kvm]() - To use CPU extensions (HVM) instead of native Qemu using emulation
* [qemu](https://www.qemu.org/) - Virtual Machine Manager
* [virt-manager](https://virt-manager.org/) - Desktop GUI to manage VMs
* [virt-viewer](https://pagure.io/virt-viewer) - Desktop GUI to view VM guests
* [whireshark](https://www.wireshark.org/) - Network protocol analyzer

###### Scripted installation software

* [afl-triforce](https://github.com/nccgroup/TriforceAFL) - AFL/QEMU fuzzer with full-system emulation
* [ccpchecker](http://cppcheck.sourceforge.net/) - Tool for Source Code Review (Static analysis of code)
* [gef](https://gef.readthedocs.io/en/master/) - GDB Plugin with extended features
* [ghidra](https://ghidra-sre.org/) - RE suite (Disassembler, Decompiler, ...)
* [katoolin](https://github.com/LionSec/katoolin) - To install automatically Kali Linux Tools
* [radamsa](https://github.com/aoh/radamsa) - General purpose Fuzzer
* [radare2](https://rada.re/n/) - 
* [sandmap]() - RE suite (Disassembler, Decompiler, Debugger, ...)
* [sqlmap](http://sqlmap.org/) - Database Pentest tool
* [z3](https://github.com/Z3Prover/z3) - Solver for Symbolic Execution

###### Pip packages

* [flawfinder](https://dwheeler.com/flawfinder/) - C/C++ source code analyzer
* [ropper](https://github.com/sashs/Ropper) - Display useful info to find ROP chains 

### Server
Specific packages for servers.

###### APT Packages

* [net-tools](http://net-tools.sourceforge.net/) - Collection of network utilities for Linux
* [openssh-server](https://help.ubuntu.com/lts/serverguide/openssh-server.html) - To create an SSH Server

###### Scripted installation software

* N/A

###### Pip packages

* N/A

### Full
All of the packets from profiles mentioned above.

## Built With

* [Bash](https://www.gnu.org/software/bash/) - The Bourne Again SHell

## Authors

* **Carles Llobet** - *Complete work* - [Github](https://github.com/CarlesLlobet)

See also the list of [contributors](https://github.com/CarlesLlobet/dotfiles/contributors) who participated in this project.

## Acknowledgments

* Project inspired by https://github.com/rayenok/dotfiles
* Project inspired by https://github.com/bketelsen/dotfiles