# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ansible-based macOS dotfiles repository that automates development environment setup. Manages configuration for programming languages, editors, terminal tools, and AI integrations.

## Key Commands

```bash
# Bootstrap everything (installs Ansible if missing, prompts for sudo)
./bin/dot-bootstrap

# Run a specific role by tag
./bin/dot-bootstrap nvim
./bin/dot-bootstrap git
./bin/dot-bootstrap zsh

# Start from a specific task within a tag
./bin/dot-bootstrap all "task name here"

# Run playbook directly
ansible-playbook -i hosts dotfiles.yml --tags nvim --ask-become-pass
```

## Architecture

### Ansible Structure

- `dotfiles.yml` — Main playbook, defines role execution order and tags
- `hosts` — Inventory file (localhost with local connection)
- `group_vars/local` — Shared variables: user paths (`dotfiles_user_home`, `dotfiles_home`), git credentials (from env vars)
- `requirements.yml` — Galaxy dependencies (community.general, osx-command-line-tools, vscode role)
- `roles/` — 28 Ansible roles, each with `tasks/`, `files/`, `defaults/`, `templates/` subdirectories as needed

### Role Conventions

- Roles are idempotent and macOS-targeted (some use `when: ansible_distribution == "MacOSX"`)
- Configuration files live in the role's `files/` directory and get symlinked to the home directory
- Existing configs are backed up with `.bak` extension on first run
- Sensitive values (git credentials, SSH passphrases) come from environment variables, never hardcoded
- Each role has a matching tag name in `dotfiles.yml` (e.g., role `nvim` → tag `nvim`)

### Neovim Configuration (`nvim/`)

Lua-based config using LazyVim framework, symlinked to `~/.config/nvim` by the `nvim` role.

- `init.lua` — Entry point, loads config modules in order: options → keymaps → autocmds → lazyvim
- `lua/config/` — Core settings (options, keymaps, autocmds, lazy plugin manager setup)
- `lua/plugins/` — Plugin specs split by concern: `core.lua` (LSP, treesitter, fzf, git, etc.), plus per-language files (`go.lua`, `java.lua`)
- `pack/github/start/copilot.vim/` — GitHub Copilot (vendored)
- Leader key is `,` (comma)

### Utility Scripts (`bin/`)

Executable scripts added to PATH. Includes `dot-bootstrap` (main entry point) and various git helpers (`git-hierarchical-branch`, `git-jump`, etc.).
