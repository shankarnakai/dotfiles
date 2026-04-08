# Testing Architecture: The `tests/` Folder

## Goal
To provide a clear, mirrored structure for verifying the success of each Ansible role without creating the overhead of a full testing framework.

## Structure
The `tests/` directory should mirror the `roles/` directory.

```
tests/
├── roles/
│   ├── git/
│   │   └── verify.yml
│   ├── zsh/
│   │   └── verify.yml
├── scripts/
│   ├── test-ubuntu.sh (Multipass)
│   ├── test-macos.sh (Tart - Placeholder for macOS)
└── verify-all.yml (Master verification playbook)
```

### How It Works
1. **Provisioning:** Use `test-ubuntu.sh` to launch a clean Multipass VM and run the main `dotfiles.yml` playbook.
2. **Verification:** Run `verify-all.yml` inside the VM. This playbook includes each `roles/<role_name>/verify.yml`.
3. **Assertive Tasks:** Each `verify.yml` should use Ansible's `stat`, `command`, or `assert` modules to confirm:
   - Packages are installed (e.g., `git --version` returns 0).
   - Files exist (e.g., `~/.zshrc` is a symlink).
   - Content is correct (e.g., `git config --global user.name` is set).

## Mandatory Virtual Environments

All testing and development work involving role verification **MUST** be performed in a virtual environment (e.g., a Multipass VM). This ensures the local system remains unaffected by experimental changes and provides a clean, reproducible state for validation.

1. **Isolation:** Use `bin/dot-test` to create an isolated environment.
2. **Reproducibility:** Always start with a fresh VM to confirm role idempotency and completeness.
3. **Safety:** Never run full dotfile playbooks directly on the host machine for testing purposes.

## Constraints: What the `tests/` folder should NOT have
1. **Secrets:** Never store `.env`, API keys, or private SSH keys in the `tests/` folder.
2. **Duplicate Logic:** Verification tasks should **check** for a state, not **create** it. If a role installs `git`, the test should check if `git` is present, not try to install it again.
3. **Massive Binary Data:** Don't store large mock files or VM images here.
4. **Platform-Specific Hardcoding:** Verification playbooks should use `ansible_os_family` to remain cross-platform (just like the roles themselves).
