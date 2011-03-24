#------------------------------------------------------------------#
# File: .zshrc ZSH resource file #
# Version: 0.1.16 #
# Author: ?yvind "Mr.Elendig" Heggstad <mrelendig@har-ikkje.net> #
#------------------------------------------------------------------#
source /etc/zsh/zprofile 
export PATH="/opt/intel/Compiler/11.1/056/bin/intel64:/usr/games/bin:/home/wut/bin/framework3:/home/wut/bin:$PATH"
export COWPATH="/usr/share/cowsay-3.03/cows:/home/wut/.cows"
export XDG_DATA_HOME=~/.config
export MANPATH="/usr/man:/usr/X11R6/man:/usr/local/man/man1:$MANPATH"
#export LESSCHARSET="latin1"
#export LESS="-R"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:processes-names' command 'ps axho command'
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#------------------------------
# History stuff
#------------------------------
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
 
#------------------------------
# Variables
#------------------------------
export EDITOR="vim"
export PAGER="less"
export GTK_IM_MODULE=scim
export QT_IM_MODULE=scim
export XIM_PROGRAM="scim -d"
export XMODIFIERS='@im=SCIM'
#export LC_CTYPE=ja_JP.utf8
#export LANG="en_US.utf8"
#export LC_COLLATE="C"
#umask 022
export MPD_HOST="localhost"
export MPD_PORT="6600"
export browser="chromium"

#export http_proxy="127.0.0.1:8123"
#export https_proxy="127.0.0.1:8123"
#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS
 
#------------------------------
# Keybindings
#------------------------------
bindkey -v
typeset -g -A key
bindkey '^r' history-incremental-pattern-search-backward
#bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
 
#------------------------------
# Alias stuff
#------------------------------

eval $(dircolors -b ~/.dir_colors)
alias ls="ls --color=auto -F --group-directories-first"
alias ll="ls --color=auto -lh"
alias lt="ls --color=auto -lthr --group-directories-first"
alias spm="sudo pacman"
alias spmc="sudo pacman-color"
alias tc='sudo truecrypt'
alias tcntfs='tc --filesystem=ntfs-3g --fs-options="umask=007,uid=`id -u`,gid=`id -g`"'
alias urxvt4='urxvt & urxvt & urxvt & urxvt'
alias userspace='cpufreq-set -c 0 -g USERSPACE && cpufreq-set -c 1 -g USERSPACE && cpufreq-set -c 0 -f 800 & cpufreq-set -c 1 -f 800'
alias ondemand='cpufreq-set -c 0 -g ONDEMAND & cpufreq-set -c 1 -g ONDEMAND'
#alias eix='yaourt -Ss'
#alias emerge='sudo pacman -S'


#------------------------------
# Comp stuff
#------------------------------
zmodload zsh/complist
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'
 
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -a -o pid,user,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
#zstyle ':completion:*:kill:*' force-list always
 
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
 
#------------------------------
# Window title
#------------------------------
case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-unicode-256color|(dt|k|E)term)
    precmd () { print -Pn "\e]0;zsh (%L) [%~]\a" }
    preexec () { print -Pn "\e]0;zsh (%L) [%~] ($1)\a" }
  ;;
    screen)
      precmd () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
    }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
    }
  ;;
esac
 
#------------------------------
# Prompt
#------------------------------
setprompt () {
  # load some modules
  autoload -U colors zsh/terminfo # Used in the colour alias below
  colors
  setopt prompt_subst
 
  # make some aliases for the colours: (coud use normal escap.seq's too)
  for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$fg[${(L)color}]%}'
  done
  PR_NO_COLOR="%{$terminfo[sgr0]%}"
 
  # Check the UID
  if [[ $UID -ge 1000 ]]; then # normal user
    eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
    eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  elif [[ $UID -eq 0 ]]; then # root
    eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
    eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  fi  
 
  # Check if we are on SSH or not --{FIXME}-- always goes to |no SSH|
  if [[ -z "$SSH_CLIENT" || -z "$SSH2_CLIENT" ]]; then
    eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
  else
    eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH
  fi

  # set the prompt
#echo `fortune tao`
PS1=$'${PR_CYAN}[${PR_USER}${PR_CYAN}@${PR_HOST}${PR_CYAN}]${PR_CYAN}[${PR_BLUE}%~${PR_CYAN}]${PR_USER_OP}'
#  PS2=$'%_>'
}
#autox
setprompt
