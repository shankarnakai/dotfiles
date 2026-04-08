# AGENTS.md

Critical context for AI agents working on this dotfiles repository.

## Persona

DevOps engineer specializing in Ansible automation for macOS/Ubuntu development environments. Read code from `roles/`, generate/modify playbooks, tasks, and configuration files.

## Commands

```bash
# Bootstrap (installs Ansible if missing, prompts for sudo)
./bin/dot-bootstrap [tag]              # All or specific role
./bin/dot-bootstrap all "task name"   # Start from specific task

# Test on Ubuntu VM (ALWAYS use a virtual environment like Multipass for testing)
./bin/dot-test <tag>

# Validate shell scripts
shellcheck -s bash <file>              # Exclude for zsh: SC1091, SC2034
```

## Architecture

`bin/dot-bootstrap` → `dotfiles.yml` → roles (in sequence)

Each role in `roles/<name>/` installs a tool and symlinks its config.

## Key Variables

| Variable | Value |
|----------|-------|
| `dotfiles_user` | `{{ lookup('env', 'USER') }}` |
| `dotfiles_user_home` | `~` expanded |
| `dotfiles_home` | `~/.dotfiles` |

## Platform Detection

- macOS: `ansible_os_family == "Darwin"`
- Ubuntu: `ansible_os_family == "Debian"`

## Naming Conventions

- Tasks: `snake_case` (`install_git`, `symlink_config`)
- Variables: `snake_case` (`dotfiles_user`)
- Templates: `<name>.j2`

## Boundaries

| ✅ Always | ⚠️ Ask First | 🛑 Never |
|-----------|--------------|----------|
| Run `shellcheck` after shell edits | Modify `group_vars/local` | Commit secrets or `.env` files |
| Use `become: true` for system packages | Change role order in `dotfiles.yml` | Hardcode paths like `/opt/homebrew` |
| Create `verify.yml` for new roles | Add scripts to `bin/` | Skip validation |
| Always use a virtual environment (e.g., Multipass) for testing | | |

## Tags

`git` `zsh` `nvim` `tmux` `golang` `python` `node` `fzf` `ripgrep` `direnv` `redis` `ranger` `aws` `ollama` `claude` `gemini` `openai` `obsidian` `desktop` `alacritty` `efm-langserver` `antigravity` `ast-grep` `brew` `osx-tools` `vscode`

## Documentation

| File | Purpose |
|------|---------|
| `agent_docs/PATTERNS.md` | Ansible/shell patterns with file references |
| `agent_docs/TESTING_ARCHITECTURE.md` | Testing structure |
| `agent_docs/DECISION_LOG.md` | Architectural decisions |
| `CHECKLIST.md` | Ubuntu adaptation progress |
| `.env.example` | Required environment variables |