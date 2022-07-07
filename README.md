# My dotfiles

Configure linux workstation using Ansible.

### Languages
Languages are managed with [asdf](https://asdf-vm.com/#/).
- Golang
- Rust
- Java
- Python
- Nodejs
- Deno
- Terraform

### System
- fzf
- git
- tmux
- neovim 
- zsh
- alacrity
- vundle

### Services
- redis

### Packages
- brew 

## Bootstrap

Firt setup installation run the dot-bootstrap command.

```bash
./bin/dot-bootstrap
```

After that you can run any scripts defined in the `$DOTFILES_PATH/bin`

```bash
dot-bootstrap
```
