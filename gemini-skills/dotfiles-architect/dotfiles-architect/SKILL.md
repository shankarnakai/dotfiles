---
name: dotfiles-architect
description: Specialized guidance for scaffolding new roles, managing tool versions, and fixing permission issues in the dotfiles repository. Use when creating a new role, adding a version-locked tool, or resolving EACCES errors.
---

# Dotfiles Architect

Ensures new roles and versions follow established patterns.

## Core Workflows

### 1. Scaffolding a New Role
- `roles/<role>/tasks/main.yml`: Entry point.
- `roles/<role>/tasks/lookup_version.yml`: Fetches latest version via API.
- `roles/<role>/tasks/debian.yml` / `mac.yml`: Platform-specific tasks.
- `tests/roles/<role>/verify.yml`: Functional verification.

### 2. Managed Version Registration
- **Add to `versions.yml`**: Define `<tool>_version: "X.Y.Z"`.
- **Add to `update-check.yml`**: Register in `tasks` and `update_results`.
- **Update `dotfiles.yml`**: Import role and add tags.

### 3. Permission Handling (EACCES)
- Prefer `~/.npm-global` for Node, `pyenv` for Python.
- Add `bin` to `roles/zsh/path.zsh`.
- Avoid `sudo` for global package installs.

## Reference Scenarios
For detailed instructions and patterns, see the `reference/` folder:
- **`atomic-extraction.md`**: Clean Install (unarchive) policy.
- **`functional-verification.md`**: Beyond simple `--version` checks.
