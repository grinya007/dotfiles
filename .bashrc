PS1="\[\033[01;33m\]$USER\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
export PAGER='less -S'
HISTSIZE=20000
LC_ALL='en_US.UTF-8'
export LC_ALL
PROMPT_COMMAND=
export PROMPT_COMMAND
EDITOR=vim
export EDITOR

if command -v brew 1>/dev/null 2>&1; then
    export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

if [ -d $HOME/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d $HOME/local/bin ]; then
    export PATH="$HOME/local/bin:$PATH"
fi

export TERM=xterm
