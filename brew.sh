#!/usr/bin/env bash
set -euo pipefail

brew update
brew upgrade

BREW_PREFIX="$(brew --prefix)"

# Core GNU tools
brew install coreutils
ln -sf "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
brew install moreutils
brew install findutils
brew install gnu-sed
brew install wget
brew install gnupg
brew install pinentry-mac

# Updated macOS tools
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Security / CTF
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp
brew install xpdf
brew install xz

# Useful binaries
brew install ripgrep
brew install openapi-generator
brew install git
brew install git-lfs
brew install imagemagick
brew install lynx
brew install 7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install tmux
brew install watchman
brew install yank
brew install lnav
brew install ncdu
brew install shfmt
brew install thefuck
brew install peco
brew install mackup
brew install zoxide   # replaces fasd

# Version manager
brew install asdf

# Cloud Foundry
brew install cloudfoundry-cli

# Shell
brew install zsh

# Languages (runtimes managed by asdf; keep system-level tools here)
brew install golang
brew install r
brew install rustup

# Databases
brew tap mongodb/brew
brew install mongodb-community@8.0
brew install mysql
brew install postgresql
brew install neo4j
brew install redis

# Android
brew install ant
brew install maven
brew install gradle

# iOS
brew install libimobiledevice
brew install libusbmuxd
brew install ideviceinstaller
brew install ios-deploy
