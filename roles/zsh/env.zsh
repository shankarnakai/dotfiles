export TERM=xterm-256color
export GPG_TTY=$(tty)

export KUBE_EDITOR='vim'

export EDITOR=nvim
export VISUAL=nvim

export FZF_DEFAULT_COMMAND="rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules/*,.git/*,tags,**/.terraform/*,.venv/*,__pycache__/*,.pytest_cache/*,.mypy_cache/*}'"

#************************************************
# RUST
#************************************************
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

#************************************************
# GO
#************************************************
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
[ -f "$HOME/.go_env" ] && go env -w $(cat ~/.go_env)

#************************************************
# JAVA
#************************************************
export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)

#************************************************
# NVM
#************************************************
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

#************************************************
# DIRENV
#************************************************
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

