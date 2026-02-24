export TERM=xterm-256color
export GPG_TTY="$(tty)"

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
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
[ -f "$HOME/.go_env" ] && go env -w "$(cat "$HOME/.go_env")"

#************************************************
# JAVA
#************************************************
_java_home="$(/usr/libexec/java_home 2>/dev/null)"
[ -n "$_java_home" ] && export JAVA_HOME="$_java_home"
unset _java_home

#************************************************
# NVM
#************************************************
export NVM_DIR="$HOME/.nvm"
_nvm_prefix="$(brew --prefix nvm 2>/dev/null)"
[ -s "$_nvm_prefix/nvm.sh" ] && source "$_nvm_prefix/nvm.sh"
[ -s "$_nvm_prefix/etc/bash_completion.d/nvm" ] && source "$_nvm_prefix/etc/bash_completion.d/nvm"
unset _nvm_prefix

#************************************************
# DIRENV
#************************************************
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
