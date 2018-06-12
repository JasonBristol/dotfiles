[ -n "$PS1" ] && source ~/.bash_profile;

# Bypass global pip requiring a virtualenv
gpip(){
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}