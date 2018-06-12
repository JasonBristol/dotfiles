# Install homebrew
which -s brew
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Run homebrew
bash brew.sh
bash brew_cask.sh

# symlink it up!
bash symlink-setup.sh

# Install theme
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rm -rf ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# set up osx defaults
bash .macos

# Create directories
mkdir -p ~/Projects ~/Virtualenvs

# Install virtualenv
gpip install virtualenv

# Create a base virtualenv
cd ~/Virtualenvs
virtualenv venv