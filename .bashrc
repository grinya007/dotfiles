PS1="\[\033[01;33m\]$USER\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
export PAGER='less -S'
HISTSIZE=20000
LC_ALL=en_US.UTF-8

export LC_ALL
PROMPT_COMMAND=
export PROMPT_COMMAND
EDITOR=nvim
export EDITOR

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v brew 1>/dev/null 2>&1; then
    export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

if [ -d $HOME/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

if [ -d $HOME/.local/lib ]; then
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/lib"
    if [ -f $HOME/.local/lib/redirect.so ]; then
        export LD_PRELOAD=redirect.so
    fi
fi

if [ -d $HOME/.local/share/nvim/lsp_servers/rust ]; then
    export PATH=$HOME/.local/share/nvim/lsp_servers/rust:$PATH
fi

if [ -d $HOME/local/bin ]; then
    export PATH="$HOME/local/bin:$PATH"
fi

if [ -d $HOME/.local/gurobi1001 ]; then
    export GUROBI_HOME="$HOME/.local/gurobi1001/linux64"
    export GRB_LICENSE_FILE="$HOME/.local/gurobi1001/gurobi.lic"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GUROBI_HOME/lib"
fi


# export TERM=xterm-24bit
. "$HOME/.cargo/env"

unset TMUX
alias to="tmux -L outer -f .tmux.outer.conf"
alias ti="tmux -L inner -f .tmux.conf"

