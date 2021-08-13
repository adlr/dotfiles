# adlr's zsh config file

HISTSIZE=2000

# Pacific Time Zone
export TZ="America/Los_Angeles"

# display error code on app exit if it returned error code != 0
# idea borrowed from comment 9 at http://pthree.org/2008/01/31/my-zsh-prompt/
#TRAPZERR () {
#  errmsg=$?
#  if [[ $errmsg -ge 128 && $errmsg -le (127+${#signals}) ]]
#  then
#    # Last process was killed by a signal. Find out what it was from
#    # the $signals environment variable.
#    errmsg="$errmsg - ${signals[$errmsg-127]}"
#  fi
#  print -P "Exit code %S$errmsg%s"
#}

# borrowed from http://aperiodic.net/phil/prompt/prompt.txt
# See if we can use colors.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
  (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ":${ref#refs/heads/}"
}

setopt prompt_subst

PROMPT="$PR_GREEN%m$PR_NO_COLOUR%(0#.$PR_LIGHT_RED.)%#$PR_NO_COLOUR "
RPROMPT='$PR_BLUE%~$PR_YELLOW$(git_prompt_info)$PR_NO_COLOUR'
export EDITOR="emacs -nw"
export PATH="/Applications/Graphviz.app/Contents/MacOS:$HOME/depot_tools:$PATH"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export PATH="${PATH}:/opt/local/bin:${HOME}/bin"

a1=/mnt/ext/adlr/chromeos
cr=/mnt/ssd/adlr/chromeos

autoload -U select-word-style
select-word-style bash

if which mdfind >/dev/null 2>/dev/null; then
	ss () {
		# spotlight search
		mdfind "$*" -onlyin . -0 | xargs -0 fgrep --color=auto "$*"
	}
fi

preexec () {
  # set the title to the dir
  # if not a mac
  if [[ $(uname) != "Darwin" ]]; then
    print -Pn "\e]0;%~ - ${(z)history[1]} - ${COLUMNS}x${LINES}\a"
  fi
}


# from http://blog.tobez.org/2009/03/how-to-time-command-execution-in-zsh.html
note_remind=0
note_ignore="yes"
note_command="?"

note_report()
{
  print -P "wall time: $note_command completed in $1 seconds"
}

preexec()
{
  if [ "x$TTY" != "x" ]; then
    note_remind="$SECONDS"
    note_ignore=""
    note_command="$2"
  fi
}

precmd()
{
  if [[ $(uname) != "Darwin" ]]; then
    print -Pn "\e]0;%~ - zsh - ${COLUMNS}x${LINES}\a"
  else
    print -Pn "\e]0;%~\a"
  fi
  
  local xx
  if [ "x$TTY" != "x" ]; then
    if [ "x$note_ignore" = "x" ]; then
      note_ignore="yes"
      xx=$(($SECONDS-$note_remind))
      if [ "$xx" -gt "10" ]; then
        if [ "$TTYIDLE" -gt "10" ]; then
          note_report $xx
        fi
      fi
    fi
  fi
}

m() {
  url=$(git cl issue 2>&1 | grep http | grep -v None | cut -d ')' -f 1 | \
        cut -d '(' -f 2)
  if [ "" != "$url" ]
  then
    echo "$url"
    ssh khakis open -a /Applications/Firefox.app "$url"
  fi
}

syncmusic() {
  rsync -arv --delete --force --modify-window=1 \
  --include '*/' \
  --include='*.mp3' \
  --include='*.MP3' \
  --include='*.m4a' \
  --include='*.M4A' \
  --include='*.AIF' \
  --include='*.aif' \
  --exclude='*' \
  "/Users/adlr/Music/iTunes/iTunes Music/" \
  "/Volumes/NO NAME/Music"
}

### Function precmd {
### 
###     local TERMWIDTH
###     (( TERMWIDTH = ${COLUMNS} - 1 ))
### 
### 
###     ###
###     # Truncate the path if it's too long.
###     
###     PR_FILLBAR=""
###     PR_PWDLEN=""
###     
###     local promptsize=${#${(%):---(%n@%m:%l)---()--}}
###     local pwdsize=${#${(%):-%~}}
###     
###     if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
### 	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
###     else
### 	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
###     fi
### 
### 
###     ###
###     # Get APM info.
### 
###     if which ibam > /dev/null; then
### 	PR_APM_RESULT=`ibam --percentbattery`
###     elif which apm > /dev/null; then
### 	PR_APM_RESULT=`apm`
###     fi
### }
### 
### 
### setopt extended_glob
### preexec () {
###     if [[ "$TERM" == "screen" ]]; then
### 	local CMD=${1[(wr)^(*=*|sudo|-*)]}
### 	echo -n "\ek$CMD\e\\"
###     fi
### }
### 
### 
### setprompt () {
###     ###
###     # Need this so the prompt will work.
### 
###     setopt prompt_subst
### 
### 
###     ###
###     # See if we can use colors.
### 
###     autoload colors zsh/terminfo
###     if [[ "$terminfo[colors]" -ge 8 ]]; then
### 	colors
###     fi
###     for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
### 	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
### 	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
### 	(( count = $count + 1 ))
###     done
###     PR_NO_COLOUR="%{$terminfo[sgr0]%}"
### 
### 
###     ###
###     # See if we can use extended characters to look nicer.
###     
###     typeset -A altchar
###     set -A altchar ${(s..)terminfo[acsc]}
###     PR_SET_CHARSET="%{$terminfo[enacs]%}"
###     PR_SHIFT_IN="%{$terminfo[smacs]%}"
###     PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
###     PR_HBAR=${altchar[q]:--}
###     PR_ULCORNER=${altchar[l]:--}
###     PR_LLCORNER=${altchar[m]:--}
###     PR_LRCORNER=${altchar[j]:--}
###     PR_URCORNER=${altchar[k]:--}
### 
###     
###     ###
###     # Decide if we need to set titlebar text.
###     
###     case $TERM in
### 	xterm*)
### 	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
### 	    ;;
### 	screen)
### 	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
### 	    ;;
### 	*)
### 	    PR_TITLEBAR=''
### 	    ;;
###     esac
###     
###     
###     ###
###     # Decide whether to set a screen title
###     if [[ "$TERM" == "screen" ]]; then
### 	PR_STITLE=$'%{\ekzsh\e\\%}'
###     else
### 	PR_STITLE=''
###     fi
###     
###     
###     ###
###     # APM detection
###     
###     if which ibam > /dev/null; then
### 	PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
###     elif which apm > /dev/null; then
### 	PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
###     else
### 	PR_APM=''
###     fi
###     
###     
###     ###
###     # Finally, the prompt.
### 
###     PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
### $PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
### $PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l\
### $PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
### $PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
### $PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\
### 
### $PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
### %(?..$PR_LIGHT_RED%?$PR_BLUE:)\
### ${(e)PR_APM}$PR_YELLOW%D{%H:%M}\
### $PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
### $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
### $PR_NO_COLOUR '
### 
###     RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
### ($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'
### 
###     PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
### $PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
### $PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
### $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
### }
### 
### setprompt# The following lines were added by compinstall

zstyle ':completion:*' completer _complete
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle :compinstall filename '/Users/adlr/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export P4CONFIG=.p4config
export P4DIFF="/home/build/public/google/tools/p4diff -b"
export P4MERGE=/home/build/public/eng/perforce/mergep4.tcl 
export P4EDITOR="$EDITOR"

# ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -z "${SSH_AUTH_SOCK}" ]; then
   if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -p ${SSH_AGENT_PID} | grep 'ssh-agent$' > /dev/null || {
         start_agent;
     }
   else
     start_agent;
  fi
fi

export NARWHAL_ENGINE=jsc

export PATH="/Users/adlr/narwhal/bin:$PATH"

# CrOS ssh command
alias cr="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -l root"
alias serve="$HOME/Code/python-http/SimpleHTTPServerWithUpload.py"
alias t="tmux attach || tmux"

if [ "$TERM" = "screen" ]; then
  export TERM=screen-256color
fi

an() {
  cd /mnt/ssd/adlr/android
  export STAY_OFF_MY_LAWN=1
  export GIT_AUTHOR_EMAIL=adlr@google.com
  export GIT_COMMITTER_EMAIL=adlr@google.com
}

and() {
  cd /mnt/ext/adlr/android
  export STAY_OFF_MY_LAWN=1
  export GIT_AUTHOR_EMAIL=adlr@google.com
  export GIT_COMMITTER_EMAIL=adlr@google.com
}

export STY=1  # Allow tmux to set window title

crouton_open_port() {
  iptables -A INPUT -p tcp --dport $1 -j ACCEPT
}

alias rvpn="sudo openvpn --config ~/Documents/rivos_vpn.txt --auth-user-pass ~/Documents/rivos_vpn.password"
