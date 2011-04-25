export PATH=/usr/local/bin:/usr/local/sbin:$PATH # brew requires this ahead of bin for some reason

# History
SAVEHIST=10000
HISTFILE=~/.zsh/history
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt NO_HIST_BEEP
setopt SHARE_HISTORY

# Unbreak broken, non-colored terminal
export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Unbreak history
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# change the way the prompt looks
#PS1=$'%{\e[0;37m%}%B%*%b %{\e[0;35m%}%m:%{\e[0;37m%}%~ %(!.#.>) %{\e[00m%}'

# navigating files and directories
set autchdir
set wildmode=list:longest

# commerce-root
alias c='clear'
alias j='jobs'
alias vi='mvim -v'
alias ee='emacs ~/.emacs'

# alias for editing and sourcing the z-script file
alias vimz='vim ~/.zshrc'
alias srcz='source ~/.zshrc; echo "Sourced!!!"'

# and suddenly I am an emacs fan so, here you go emacs
alias ez='emacs ~/.zshrc'

# rails 3 project specific
alias proj='cd ~/Desktop/rails_project/sample_app'

# temp variables
export tempfile=$HOME/tempfile
export temprankfile=$HOME/temprankfile

PS1="[%T][%n@%M][%d]$ "
zmodload zsh/complist
autoload -U compinit && compinit

### If you want zsh's completion to pick up new commands in $path automatically
#### comment out the next line and un-comment the following 5 lines
#zstyle ':completion:::::' completer _complete _approximate
##_force_rehash() {
##  (( CURRENT == 1 )) && rehash
##  return 1# Because we didn't really complete anything
##}
#zstyle ':completion:::::' completer _force_rehash _complete _approx zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes

local _myhosts
if [[ -f $HOME/.ssh/known_hosts ]]; then
  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
  zstyle ':completion:*' hosts $_myhosts
fi

zstyle ':completion:*:kill:*:processes' command "ps x"

export TERM='xterm-color'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session *as a function*

# experimental stuff, but really cool
# stolen from http://dasdasich.blogspot.com/2010/06/current-git-branch-in-zsh-prompt.html
autoload -U colors && colors
autoload -Uz vcs_info

zstyle ':vcs_info:*:prompt:*' formats "$VCSPROMPT" "(%b)"

precmd1() {
    vcs_info 'prompt'
    if [ -n vcs_info_msg_0_ ]; then
	RPROMPT="${vcs_info_msg_1_}"
    else
	RPROMPT=""
    fi
}

PROMPT=$'[%F{green}%~%f] '