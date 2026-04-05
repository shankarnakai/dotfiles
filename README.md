# My Dotfiles

Configure Linux/macOS workstations using Ansible automation.

## Supported Platforms

- **Ubuntu/Debian** - Primary target with full role support
- **macOS** - Homebrew-based installation with additional macOS-specific roles

## Requirements

- `ansible` (installed automatically by the bootstrap script)
- `sudo` privileges (for system package installation)

## Installation

Clone the repository and run the bootstrap script:

```bash
git clone git@github.com:shankarnakai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bin/dot-bootstrap
```

The bootstrap script will:
1. Install Ansible if not present (via Homebrew on macOS or apt on Linux)
2. Install required Ansible Galaxy roles
3. Prompt for sudo password (if needed)
4. Execute the Ansible playbook to configure your environment

## Install Specific Roles

Install only the roles you need using tags:

```bash
# Install specific roles by tag
./bin/dot-bootstrap git
./bin/dot-bootstrap zsh
./bin/dot-bootstrap nvim

# Install multiple roles
./bin/dot-bootstrap --tags git,zsh,nvim

# Use --tags flag (equivalent)
./bin/dot-bootstrap --tags git
```

### Available Tags

| Tag | Description |
|-----|-------------|
| `git` | Git configuration with custom aliases |
| `zsh` | Zsh shell with Oh My Zsh and plugins |
| `tmux` | Terminal multiplexer with configuration |
| `nvim` | Neovim with init.vim and plugin management |
| `fzf` | Fuzzy finder integration |
| `ripgrep` | Fast grep alternative |
| `direnv` | Directory-specific environment variables |
| `golang` | Go programming language |
| `python` | Python via pyenv |
| `node` | Node.js via nvm |
| `docker` | Docker installation |
| `redis` | Redis server |
| `ranger` | Terminal file manager |
| `aws` | AWS CLI v2 |
| `ollama` | Local LLM inference |
| `claude` | Anthropic Claude CLI |
| `gemini` | Google Gemini CLI |
| `openai` | OpenAI CLI tools |
| `obsidian` | Obsidian knowledge base |
| `vscode` | Visual Studio Code with extensions |
| `brew` | Homebrew (macOS only) |
| `osx-tools` | Xcode command line tools (macOS only) |
| `alacritty` | GPU-accelerated terminal |
| `efm-langserver` | General-purpose language server |
| `antigravity` | AI-powered code assistance |
| `ast-grep` | AST-based code search tool |
| `desktop` | Desktop environment settings |

## Advanced Usage

### Start at a Specific Task

Resume installation from a particular task:

```bash
./bin/dot-bootstrap git --start-at-task "setup_git_config"
```

### Skip Become Password Prompt

Set the password file environment variable:

```bash
export ANSIBLE_BECOME_PASSWORD_FILE=~/.password_file
./bin/dot-bootstrap
```

Or use the skip flag (requires password file):

```bash
./bin/dot-bootstrap --skip-become-pass
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `dotfiles_user` | Username for configuration | Current user |
| `dotfiles_user_home` | Home directory path | `~` |
| `dotfiles_home` | Dotfiles repository path | `~/.dotfiles` |
| `ANSIBLE_BECOME_PASSWORD_FILE` | Path to sudo password file | (none) |

### Custom Configuration

Add user-specific variables in:

```bash
# Linux
~/.dotfiles/group_vars/local

# macOS
~/.dotfiles/group_vars/darwin
```

## Architecture

```
dotfiles/
├── bin/
│   └── dot-bootstrap        # Main bootstrap script
├── roles/                  # Ansible roles (one per tool)
├── dotfiles.yml           # Main playbook
├── hosts                  # Inventory file
└── requirements.yml       # Ansible Galaxy dependencies
```

Each role follows the pattern:
1. Install the tool/package
2. Create configuration files from templates
3. Symlink config to home directory

## Testing

Run the playbook against an Ubuntu VM:

```bash
./tests/scripts/test-ubuntu.sh --tags <tag>
```

## Troubleshooting

### Ansible not found

The bootstrap script installs Ansible automatically. If it fails, install manually:

```bash
# macOS
brew install ansible

# Ubuntu
sudo apt-get update && sudo apt-get install -y ansible
```

### Permission denied errors

Ensure you have sudo privileges. The script will prompt for your password.

### Partial installation

Use tags to retry specific roles that failed:

```bash
./bin/dot-bootstrap --tags git,nvim,zsh
```

## Uninstallation

Run the uninstall role (when available):

```bash
./bin/dot-bootstrap uninstall
```

## Contributing

1. Create a branch for your changes
2. Test with `./tests/scripts/test-ubuntu.sh --tags <role-name>`
3. Run `shellcheck -s bash bin/*` to validate scripts
4. Submit a pull request
