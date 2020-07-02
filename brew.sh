#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

# Install `wget`.
brew install wget

# Install GnuPG to enable PGP-signing commits.
# brew install pinentry-mac
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
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
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install other useful binaries.
brew install ack
brew install openapi-generator
brew install git
brew install git-lfs
brew install imagemagick
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install yarn
brew install nvm
brew install tmux
brew install icarus-verilog
brew install watchman
brew install yank
brew install fasd
brew install lnav
brew install peco
brew install ncdu
brew install shfmt
brew install mackup
brew install thefuck
# Cloud Foundry
brew tap cloudfoundry/tap
brew install cf-cli

# Shells
brew install zsh

# Languages
brew install lua
brew install python3
brew install golang
brew install erlang
brew install elixir
brew install clojure
brew install r
brew install nim
brew install node
brew install deno
# Rust
brew install rust
brew install rustup
# Haskell
brew install ghc
brew install haskell-stack

# DBMS
brew install mongodb
brew install mysql
brew install postgresql
brew install neo4j
brew install redis

# Android dev
brew install ant
brew install maven
brew install gradle

# iOS dev
brew update
brew install --HEAD usbmuxd
brew link usbmuxd
brew install --HEAD libimobiledevice
brew install ideviceinstaller
brew install ios-deploy
