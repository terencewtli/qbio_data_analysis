# ~/.bashrc: executed by bash(1) for non-login shells.
#

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
	

#If not run interactively, don't do anything
[ -z "$PS1" ] && return

#export PS1='\h:\w\$ '
umask 022


# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='-F --color=auto'			#append *=exec, @=link and /=folder and add colors if available
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'                            # Long Listing
alias lh='ls $LS_OPTIONS -alh'                          # Long Listering with Human readable sizes
alias lt='ls $LS_OPTIONS -altr'                         # Long listing sorted by creation time
# alias l='ls $LS_OPTIONS -lA'
alias rm='rm -i'                                        # Always confirm file removal
alias mv='mv -i'                                        # Always confirm file mv to prevent override
alias cp='cp -i'                                        # Always confirm file mv to prevent override
alias em='emacs -nw -fg black -bg white'                # Default colors for emacs
alias m='less'                                          # Alias for less
alias l='less'                                          # Alias for less
alias moer='less'                                       # Mistipying more executes less
alias mroe='less'                                       # Mistipying more executes less
alias more='less'                                       # Mistipying more executes less
alias s='source'
alias myjobs='squeue -u $USER -o "%.8i %.9P %.30j %.12T %.12M %.12L %.8N"' 
alias anycore='salloc -p cmb  --ntasks=1 --mem-per-cpu=2000mb --time=30-00:00:00'
alias clstat='sinfo   --Node -O nodehost:10,statecompact:.10,memory:.9,allocmem:.9,freemem:.9,cpusstate:.15,cpusload:.9,features:.42'


# Function to request a specific node type node nodename
function node() {
echo $1
salloc -p cmb  --ntasks=1 --nodelist=$1 --time=30-00:00:00
}

# Source  more USER specifc aliases
if [ -e $HOME/.alias ]
then
	source $HOME/.alias
fi

# If this is an xterm set the title to user@host:dir
case $TERM in
xterm*)
    echo "XTERM"	
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    TERM=xterm
    ;;
*)
    ;;
esac


# Define ANSI color sequences
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color
NORMAL="\[\033[0m\]"
BOLD="\[\033[1m\]"
WHITE="\[\033[0;37m\]"
BRIGHTGREEN="\[\033[1;32m\]"
BRIGHTBLUE="\[\033[1;34m\]"
BRIGHTPURPLE="\[\033[1;35m\]"
BRIGHTRED="\[\033[1;31m\]"
BRIGHTCYAN="\[\033[1;36m\]"

# Find out if we are root
if [ $UID -eq 0 ] ; then
# If root make the hole prompt RED
# The # character serves as an extra reminder that I am root
        SYM='#'
        P1="$BRIGHTRED\u$@\h(\w)\n(\$?)$SYM$NORMAL"
        export PS1="$P1"
else
        SYM='>'
        P1="$BOLD\u$BRIGHTPURPLE@$BRIGHTGREEN"
        P2="\h$BRIGHTCYAN(\w$BRIGHTCYAN"
        P3=")\n$BOLD(\$?)$BRIGHTPURPLE$SYM$NORMAL "
        export PS1="$P1$P2$P3"
fi

# Say Welcome from the node we login
echo "Welcome to $HOSTNAME"

# Add RLIBS Var for R (you need to have R_LIBS in your cmd dir.
export R_LIBS=$HOME/R_LIBS

# Set the umask to file creation so that my group members care search and read my files
umask 002

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

