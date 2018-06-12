# Set mac defaults
./.macos

# Install brew dependencies
./brew.sh

# Bootstrap it!
set -- -f; source bootstrap.sh

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