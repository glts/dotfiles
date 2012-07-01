echo "Sourcing .bashrc ..."

HISTSIZE=1000
HISTCONTROL=erasedups

shopt -s cdspell

export LC_CTYPE=en_US.UTF-8

editor="vim"
if [ -x "$(which mvim)" ]; then
	editor="m${editor} -f"
elif [ -x "$(which gvim)" ]; then
	editor="g${editor} -f"
fi
export EDITOR="${editor}"

# Prompts
export PS1="\u@\h:\[\e[1m\]\w\[\e[0m\]\$ "
export PS2="… "
export PS3="Which # ? "

alias la="ls -al"
alias mvimr='mvim --remote-tab'
