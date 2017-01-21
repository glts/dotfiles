# Return early if not running as an interactive shell. bashrc is not normally
# read in that case but this protects against some situations where it is.
[[ $- != *i* ]] && return

# Disable terminal flow control to free up C-s and C-q.
stty -ixon

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell

# Prefer GVim as default editor.
if [[ -x "$(which gvim)" ]]
then
    export EDITOR='gvim -f'
else
    export EDITOR='vim'
fi

# Sensible encoding settings for Perl according to perlrun(1).
export PERL_UNICODE=SDA

# Make less(1) support more input formats, see lesspipe(1).
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Colourful LS_COLORS setting and aliases, see dircolors(1).
if [[ -x /usr/bin/dircolors ]]
then
    [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias la='ls -alF'
alias lr='ls -alrt'

# Enable Bash's programmable completion.
if [[ -f /usr/share/bash-completion/bash_completion ]]
then
    . /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]
then
    . /etc/bash_completion
fi
