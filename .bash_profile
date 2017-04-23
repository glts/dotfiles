# Keep private modifications to PATH and friends in .profile (which is prepared
# automatically on Ubuntu, see /etc/skel).
source "$HOME/.profile"
[[ $- != *i* ]] || source "$HOME/.bashrc"
