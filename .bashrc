#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# File and dirs
alias ll='ls -l'
alias la='ls -A'
alias ..='cd ..'

# Git
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gd='git diff'
alias gco='git checkout'

# Applications
alias yy='yazi'
alias vim='nvim'
alias vm='virsh'
alias lg='lazygit'
alias bt='bluetui'

# Prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  color_prompt=yes
fi

if [ "$color_prompt" = yes ]; then
  PS1='\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \$ '
else
  PS1='[\u@\h \W]\$ '
fi
export PATH="$HOME/.local/bin:$PATH"

export LIBVIRT_DEFAULT_URI=qemu:///system
