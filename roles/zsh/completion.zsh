complete -C '$(which aws_completer)' aws-okta

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

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
  compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi
