# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Run homebrew
sudo ./brew.sh

# set up osx defaults
sudo sh .macos

# symlink it up!
sudo ./symlink-setup.sh

# Create directories
mkdir -p ~/Projects ~/Virtualenvs ~/Library/Application\ Support/pip

# Prevent global pip
touch -a ~/Library/Application\ Support/pip/pip.conf
cat <<EOT >> ~/Library/Application\ Support/pip/pip.conf
[install]
require-virtualenv = true

[uninstall]
require-virtualenv = true
EOT

# Install virtualenv
gpip install virtualenv

# Create a base virtualenv
cd ~/Virtualenvs
virtualenv venv