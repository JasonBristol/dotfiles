# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Run homebrew
bash brew.sh
bash brew_cask.sh

# set up osx defaults
bash .macos

# symlink it up!
bash symlink-setup.sh

# Create directories
mkdir -p ~/Projects ~/Virtualenvs ~/Library/Application\ Support/pip

# Install virtualenv
source ~/.bashrc
gpip install virtualenv

# Create a base virtualenv
cd ~/Virtualenvs
virtualenv venv