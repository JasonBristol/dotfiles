sudo -v

# Create directories
mkdir -p ~/Projects ~/Virtualenvs
sudo chown -R jbristol ~/Projects ~/Virtualenvs

# Install homebrew
which -s brew
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Run homebrew
bash brew.sh
bash brew_cask.sh

# Install theme
wget -xqO ~/.oh-my-zsh/themes/aphrodite.zsh-theme https://git.io/v5ohc

# symlink it up!
bash symlink-setup.sh

# Install sonic-pi-cli
cargo install --git https://github.com/lpil/sonic-pi-tool/

# Setup RVM
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L https://get.rvm.io | bash -s stable --ruby

# Install virtualenv
source ~/.zshrc
gpip install virtualenv

# Create base virtualenvs
cd ~/Virtualenvs
virtualenv venv
virtualenv -p $(which python2) py2

# Setup cocoa pods
# TODO broken ruby version
pod setup

# Setup flutter
git clone -b v1.1.4 https://github.com/flutter/flutter.git ~/Documents/flutter --single-branch
source ~/.zshrc
flutter doctor --android-licenses
flutter doctor

# Setup setting backup
mackup backup -f

# Setup osx defaults
bash .macos
