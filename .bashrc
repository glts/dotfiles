echo "Sourcing .bashrc ..."

export TERM=xterm-256color

HISTSIZE=1000
HISTCONTROL=erasedups
CDPATH=".:$HOME:$HOME/code"

stty -ixon

shopt -s cdspell

export LC_CTYPE=en_US.UTF-8

editor="vim"
if [ -x "$(which mvim)" ]; then
	editor="m${editor} -f"
elif [ -x "$(which gvim)" ]; then
	editor="g${editor} -f"
fi
export EDITOR="${editor}"

export CTAGS='--langmap=Lisp:+.clj'

# Prompts
export PS1="\u@\h:\[\e[1m\]\w\[\e[0m\]\$ "
export PS2="… "
export PS3="Which # ? "

export PERL_UNICODE=SAD
# alternatively:
export PERL5OPTS=-Mopen=:utf8,:std
# But look these up first!

alias la="ls -al"
alias mvimr='mvim --remote-tab'
