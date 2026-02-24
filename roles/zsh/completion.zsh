autoload -U +X bashcompinit && bashcompinit

command -v aws_completer &>/dev/null && complete -C "$(command -v aws_completer)" aws-okta

_terraform="$(command -v terraform 2>/dev/null)"
[ -n "$_terraform" ] && complete -o nospace -C "$_terraform" terraform
unset _terraform

# zsh completion for codex
compdef _codex codex

_codex() {
  _arguments '*:filename:_files'
}

_gitignoreio_get_command_list() {
  curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' "$(_gitignoreio_get_command_list)"
}

compdef _gitignoreio gi
