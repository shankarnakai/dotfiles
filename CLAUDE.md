# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal dotfiles repository for setting up a macOS development environment. Each tool's configuration (dotfiles) lives here and gets placed in the right location on the system. Ansible is used to automate installation and configuration of each tool.

### Stack

- **Languages:** Go (official binary), Python (pyenv), Node.js (Homebrew), Terraform
- **Editor:** Neovim (LazyVim), VS Code
- **Terminal:** Zsh (Oh-My-Zsh), Tmux, Alacritty, FZF, ripgrep
- **AI tools:** Claude, Ollama, OpenAI, Gemini
- **Services:** Redis
- **Other:** Git, direnv, Ranger, AWS CLI, Postman, Obsidian

## Key Commands

```bash
# Bootstrap everything (installs Ansible if missing, prompts for sudo)
./bin/dot-bootstrap

# Install/configure a single tool by tag
./bin/dot-bootstrap nvim
./bin/dot-bootstrap git
./bin/dot-bootstrap zsh

# Start from a specific task within a tag
./bin/dot-bootstrap all "task name here"

# Run playbook directly
ansible-playbook -i hosts dotfiles.yml --tags nvim --ask-become-pass
```

## How It Works

`bin/dot-bootstrap` is the entry point. It installs Ansible if needed, pulls Galaxy dependencies, then runs `dotfiles.yml` — the main playbook that applies roles in order.

### Roles (`roles/`)

Each tool has its own Ansible role (e.g., `roles/nvim/`, `roles/git/`, `roles/zsh/`). A role typically:
1. Installs the tool (via Homebrew, binary download, etc.)
2. Symlinks the dotfile from this repo (usually in the role's `files/` directory) to the expected location on the system (e.g., `~/.config/nvim`, `~/.gitconfig`, `~/.zshrc`)
3. Backs up any existing config with a `.bak` extension on first run

Each role has a matching tag in `dotfiles.yml` so it can be run individually.

### Key Files

- `dotfiles.yml` — Main playbook, defines role execution order and tags
- `hosts` — Ansible inventory (localhost, local connection)
- `group_vars/local` — Shared variables: paths (`dotfiles_user_home`, `dotfiles_home`) and git credentials (read from environment variables)
- `requirements.yml` — Ansible Galaxy dependencies

### Neovim Configuration (`nvim/`)

Lua-based config using LazyVim framework, symlinked to `~/.config/nvim` by the `nvim` role.

- `init.lua` — Entry point, loads modules in order: options → keymaps → autocmds → lazyvim
- `lua/config/` — Core settings (options, keymaps, autocmds, lazy plugin manager bootstrap)
- `lua/plugins/` — Plugin specs split by concern: `core.lua` (LSP, treesitter, fzf, git, etc.), plus per-language files (`go.lua`, `java.lua`)
- Leader key is `,` (comma)

### Utility Scripts (`bin/`)

Executable scripts added to PATH. Includes `dot-bootstrap` and various git helpers.
