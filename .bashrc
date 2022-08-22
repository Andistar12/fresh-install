# My custom .bashrc, intended to run inside tmux alongside the Iceberg Vim theme
# Assumes that 256 color support is supported, but has non-color support

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Screw EOF
set -o ignoreeof

# Bash history settings
HISTCONTROL=ignoreboth # Ignore dupe lines and lines starting with space
shopt -s histappend # Append instead of overwrite
HISTSIZE=1000
HISTFILESIZE=2000

# Update terminal window on resize
shopt -s checkwinsize

# Detect that we are in a 256 color terminal
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
fi

# Enable colors if supported
if [ "$color_prompt" = yes ]; then

    # Enable color for certain apps
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
 
    export PS1="\[\033[38;1;251;48;5;239m\] \T \[\033[48;5;237m\]\w\[\033[0m\]|> "
    export LS_COLORS="di=38;5;110:fi=38;5;250:ex=38;5;250:ln=target"
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
else
    export PS1=" \@ \w|>"
fi
unset color_prompt

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Startup with tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    attach=$(tmux ls -F '#{session_name}|#{?session_attached,attached,not attached}' 2>/dev/null | grep 'not attached$' | tail -n 1 | cut -d '|' -f1)
    tmux attach -t $attach 2> /dev/null || tmux
    exit
fi

# Make less default to vim
export EDITOR=vim
# Screw pip10 breaking stuff
alias pip3="sudo python3 -m pip"
alias pipenv="python3 -m pipenv"
# Sommelier for Chromebook
alias steam="CPU_MHZ="2300.000" sommelier -X --scale=0.8 --dpi=160 /usr/games/steam %U"
alias scaled="pwd | scaledw"
scaledw() {
    # Argument 0 is function call, 1 is working dir, 2 is scale, 3 and on is command 
    currdir=$(</dev/stdin)
    scale=$1
    echo "Using scale $scale in directory $currdir"
    shift
    cd "$currdir"
    sommelier -X --scale=$scale --dpi=160 "$@"
}
# Terminal session recording command
alias record='curr_date="$(date +%y%m%d_%H%M%S)"; script $curr_date.log --timing=$curr_date.time.log'
# Helpful recursive findtext command
alias findtext="grep -irnl . --exclude-dir=node_modules -e"
# For NPM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
