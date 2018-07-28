[ -n "$PS1" ] && source ~/.bash_profile;

# Bypass global pip requiring a virtualenv
gpip(){
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
