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

# Enable dark-mode
dark-mode on

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
source ~/.bashrc
gpip install virtualenv

# Create a base virtualenv
cd ~/Virtualenvs
virtualenv venv

# set up osx defaults
bash .macos
