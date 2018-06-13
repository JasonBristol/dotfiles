# Create directories
mkdir -p ~/Projects ~/Virtualenvs
sudo chown -R jbristol ~/Projects ~/Virtualenvs 

# Install homebrew
which -s brew
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Run homebrewJ
# bash brew.sh
bash brew_cask.sh

# symlink it up!
bash symlink-setup.sh

# Install theme
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir -p ~/.oh-my-zsh/custom/themes/
wget -xqO ~/.oh-my-zsh/custom/themes/aphrodite.zsh-theme https://git.io/v5ohc
sed -i.bak 's/^[[:space:]]*ZSH_THEME=.*/ZSH_THEME="aphrodite"/' ~/.zshrc
source ~/.zshrc

# set up osx defaults
bash .macos

# Install virtualenv
source ~/.bashrc
gpip install virtualenv

# Create a base virtualenv
cd ~/Virtualenvs
virtualenv venv