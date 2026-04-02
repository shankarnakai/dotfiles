# Ubuntu Adaptation Checklist

This checklist tracks the progress of making each Ansible role cross-platform (Ubuntu & macOS).

## Guidelines
- **Test First:** Create/update `tests/roles/<role>/verify.yml` before refactoring.
- **Isolate:** Use `multipass` (via `tests/scripts/test-ubuntu.sh`) for all Ubuntu testing.
- **Cross-Platform:** Use `ansible_os_family` or `ansible_distribution` to branch logic. Avoid hardcoding paths like `/opt/homebrew`.

---

## Phase 1: Core System & Shell
- [ ] **Role: git**
  - [x] Create `tests/roles/git/verify.yml`
  - [x] Refactor `roles/git/tasks/main.yml` (Replace `homebrew` with `apt`/`package`)
  - [ ] Verify on Ubuntu (`./tests/scripts/test-ubuntu.sh --tags git`)
  - [ ] Verify on macOS (via GitHub Actions or local Mac)

- [ ] **Role: zsh**
  - [x] Create `tests/roles/zsh/verify.yml`
  - [x] Refactor `roles/zsh/tasks/main.yml`
  - [ ] Verify on Ubuntu

- [ ] **Role: tmux**
  - [x] Create `tests/roles/tmux/verify.yml`
  - [x] Refactor `roles/tmux/tasks/main.yml`
  - [ ] Verify on Ubuntu

---

## Phase 2: Languages & Runtimes
- [x] **Role: python**
- [x] **Role: golang**
- [x] **Role: node**

---

## Phase 3: Editors & Tools
- [x] **Role: nvim**
- [x] **Role: fzf**
- [x] **Role: ripgrep**
- [x] **Role: direnv**

---

## Phase 4: Services & Apps
- [x] **Role: redis**
- [x] **Role: docker**
- [x] **Role: alacritty**

---

## Phase 5: AI & Specialized Tools
- [x] **Role: ollama**
- [x] **Role: claude**
- [x] **Role: gemini**
- [x] **Role: openai**

---

## Phase 6: Final Integration
- [ ] **Full Bootstrap Test** (Run entire `dotfiles.yml` on a clean Ubuntu VM)
- [x] **GitHub Actions Setup** (Automated macOS/Ubuntu testing on push)
