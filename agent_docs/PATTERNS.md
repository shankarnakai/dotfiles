# Ansible and Shell Patterns

Reference examples for common patterns used in this repository. Point your LLM to specific files for concrete implementations.

## Ansible Patterns

### Symlink Config File

Point to: `roles/git/tasks/main.yml` (gitignore_global.link symlink)

```yaml
- name: Link global gitignore file
  file:
    src: "{{ dotfiles_home }}/roles/git/files/gitignore_global.link"
    dest: "{{ dotfiles_user_home }}/.gitignore_global"
    state: link
    force: yes
```

### Backup Before Symlink

Point to: `roles/git/tasks/main.yml` (gitconfig backup pattern)

```yaml
- name: Check if file exists
  stat:
    path: "{{ dotfiles_user_home }}/.gitconfig"
  register: file_stat

- name: Back up file
  command: mv ~/.gitconfig ~/.gitconfig.bak
  args:
    creates: "{{ dotfiles_user_home }}/.gitconfig.bak"
  when: file_stat.stat.exists and not file_stat.stat.islnk
```

### Platform-Specific Tasks

Point to: `roles/nvim/tasks/main.yml` or `roles/brew/tasks/main.yml`

```yaml
# In tasks/main.yml
- import_tasks: mac.yml
  when: ansible_os_family == "Darwin"

# In tasks/mac.yml (macOS-specific)
- name: Install via Homebrew
  homebrew:
    name: neovim
    state: present
```

### Cross-Platform Package Installation

Point to: `roles/git/tasks/main.yml` (uses `package` module for both macOS and Ubuntu)

```yaml
- name: Install Git
  package:
    name: git
    state: present
  become: true
```

### Jinja2 Template with Variables

Point to: `roles/git/templates/gitconfig.j2`

Uses variables from `group_vars/local` like `personal_git_email`, `work_git_email`, `github_work_orgs`.

### Ensure Directory Exists

Point to: `roles/nvim/tasks/main.yml`

```yaml
- name: Ensure ~/.config directory exists
  file:
    path: "{{ dotfiles_user_home }}/.config"
    state: directory
    mode: "0755"
```

## Shell Script Patterns

Point to: `bin/dot-bootstrap` for the main entry point script.

### Entry Point Pattern

```bash
#!/usr/bin/env bash
set -e

tags="$1"
skip_become_pass="$2"

# Install Ansible if missing
if ! [ -x "$(command -v ansible)" ]; then
  # Platform detection
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install ansible
  elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y ansible
  fi
fi

# Run playbook
ansible-playbook -i hosts dotfiles.yml --tags "$tags"
```

### Validation

Always run after modifying shell scripts:

```bash
shellcheck -s bash <file>
```

Exclude for zsh-specific files: SC1091 (can't follow source), SC2034 (zsh variables like `ZSH_THEME`, `plugins`).

## Directory Structure

```
roles/<name>/
├── tasks/main.yml       # Main task definitions (required)
├── tasks/mac.yml        # macOS-specific tasks (optional)
├── files/               # Config files to symlink
├── templates/           # Jinja2 templates (.j2)
└── defaults/main.yml    # Default variables (optional)
```

## Directory Permissions

| Directory | Read | Write | Notes |
|-----------|------|-------|-------|
| `roles/*/tasks/` | ✅ | ✅ | Main task definitions |
| `roles/*/files/` | ✅ | ✅ | Config files for symlinking |
| `roles/*/templates/` | ✅ | ✅ | Jinja2 templates |
| `group_vars/` | ✅ | ⚠️ | Ask before modifying shared variables |
| `tests/` | ✅ | ✅ | Verification playbooks |
| `bin/` | ✅ | ⚠️ | Ask before adding utility scripts |

## Environment Variables

Required for git/SSH configuration (see `.env.example`):

```bash
PERSONAL_GIT_EMAIL=""      # Personal git email
WORK_GIT_NAME=""            # Work git name
WORK_GIT_EMAIL=""           # Work git email
GITHUB_WORK_ORGS=""         # Comma-separated GitHub orgs
GITHUB_WORK_SSH_PASSPHRASE=""  # SSH key passphrase (optional)
```

## File References by Use Case

| I want to... | Reference file |
|--------------|----------------|
| Add a new role | `roles/git/tasks/main.yml` (minimal), `roles/nvim/tasks/main.yml` (with platform split) |
| Symlink a config | `roles/git/tasks/main.yml` (gitignore_global.link) |
| Backup before symlink | `roles/git/tasks/main.yml` (gitconfig backup) |
| Use Jinja2 templates | `roles/git/templates/gitconfig.j2`, `roles/git/templates/ssh_config.j2` |
| Handle platform differences | `roles/nvim/tasks/main.yml`, `roles/git/tasks/main.yml` |
| Create verify.yml test | `tests/roles/git/verify.yml`, `tests/roles/zsh/verify.yml` |