# Atomic Extraction Pattern (Clean Install)

This pattern ensures that a tool installation is always performed in a clean directory, preventing "ghost file" corruption from previous versions.

## Requirements
- Target directory must be fully removed before extraction.
- Extraction should be conditional based on version checks.

## Ansible Implementation
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
