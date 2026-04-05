---
name: dotfiles-architect
description: Specialized guidance for scaffolding new roles, managing tool versions, and fixing permission issues in the dotfiles repository. Use when creating a new role, adding a version-locked tool, or resolving EACCES errors.
---

# Dotfiles Architect

This skill ensures that new roles and tool versions are integrated into the repository using established patterns.

## Workflows

### 1. Scaffolding a New Role
When creating a new role (e.g., `mytool`), you must create this structure:
- `roles/mytool/tasks/main.yml`: Primary entry point.
- `roles/mytool/tasks/lookup_version.yml`: Fetches the latest stable version.
- `roles/mytool/tasks/debian.yml` / `roles/mytool/tasks/mac.yml`: Platform-specific tasks.
- `tests/roles/mytool/verify.yml`: Functional verification (e.g., compile and run).

### 2. Managed Version Registration
When adding a tool that needs version locking:
1.  **Add to `versions.yml`**: Define `<tool_name>_version: "X.Y.Z"`.
2.  **Add to `update-check.yml`**: 
    - Add a block to `tasks` that includes `roles/<tool_name>/tasks/lookup_version.yml`.
    - Append the result to `update_results` list using `set_fact`.
3.  **Update `dotfiles.yml`**: Ensure the role is imported and correctly tagged.

### 3. Fixing Permissions (EACCES)
For Node.js and Python tools:
- Prefer using a local prefix (e.g., `~/.npm-global` for Node, `pyenv` for Python).
- Add the corresponding `bin` directory to the `PATH` in `roles/zsh/path.zsh`.
- **Mandate**: Avoid using `sudo` for global package installs (like `npm install -g`) by correctly setting up the user-level path and prefix.

## Reference Patterns

### Atomic Extraction Pattern (Clean Install)
```yaml
- name: Remove old installation
  file:
    path: /usr/local/toolname
    state: absent
  become: true
  when: current_version.stdout != target_version

- name: Extract tool
  unarchive:
    src: "{{ download_url }}"
    dest: "/usr/local"
    remote_src: true
  become: true
  when: current_version.stdout != target_version
```

### Functional Verification Pattern
```yaml
- name: Verify compilation and execution
  command: /usr/local/bin/mytool run -e 'print("OK")'
  register: verify_output
  failed_when: verify_output.stdout != "OK"
```
