# Git Role

Installs Git, deploys gitconfig, SSH config, and generates SSH keys for multi-account GitHub/Bitbucket access.

## Multi-Account Routing

The setup uses SSH host aliases + Git URL rewrites + conditional includes to route repos to the correct SSH key and identity. Personal identity is the default; only work repos need explicit routing.

### SSH Config (`templates/ssh_config.j2`)

| Host | Key | Purpose |
|------|-----|---------|
| `github-work` | `id_ed25519_github_work` | SSH alias for work GitHub repos |
| `github.com` | `id_ed25519_github_personal` | Default key for all other GitHub repos |
| `bitbucket.org` | `id_ed25519_bitbucket_work` | Bitbucket (work only) |

### URL Rewrites (`templates/gitconfig.j2`)

Git's `[url "..."] insteadOf` rules rewrite clone URLs. Longest prefix wins:

1. `https://github.com/WORK_ORG/` -> `git@github-work:WORK_ORG/` (caught first, uses work key)
2. `https://github.com/` -> `git@github.com:` (catch-all, uses personal key)
3. `https://bitbucket.org/` -> `git@bitbucket.org:` (uses work key)

### Identity Selection

- **Default `[user]` block** in gitconfig has personal name/email — applies to all repos unless overridden.
- **`[includeIf "hasconfig:remote.*.url:git@github-work:**"]`** loads `~/.gitconfig-work` (work name/email) for work GitHub repos.
- **`[includeIf "hasconfig:remote.*.url:git@bitbucket.org:**"]`** loads `~/.gitconfig-work` for Bitbucket repos.
- No `includeIf` needed for personal — the default `[user]` handles it.

### End-to-End Flow

```
Work repo:     https://github.com/WORK_ORG/repo
  -> URL rewrite  -> git@github-work:WORK_ORG/repo
  -> SSH config   -> github.com + work key
  -> includeIf    -> ~/.gitconfig-work (work name/email)

Personal repo: https://github.com/user/repo
  -> URL rewrite  -> git@github.com:user/repo
  -> SSH config   -> github.com + personal key
  -> no includeIf -> default [user] (personal name/email)

Bitbucket:     https://bitbucket.org/team/repo
  -> URL rewrite  -> git@bitbucket.org:team/repo
  -> SSH config   -> bitbucket.org + work key
  -> includeIf    -> ~/.gitconfig-work (work name/email)
```

### Templates

- `gitconfig.j2` -> `~/.gitconfig` (aliases, URL rewrites, includeIf rules)
- `gitconfig-work.j2` -> `~/.gitconfig-work` (work `[user]` override)
- `ssh_config.j2` -> `~/.ssh/config` (host aliases with key assignments)

### Required Environment Variables

```bash
PERSONAL_GIT_EMAIL     # Personal email for commits
WORK_GIT_NAME          # Work display name
WORK_GIT_EMAIL         # Work email for commits
GITHUB_WORK_ORG        # GitHub org name for work URL routing
```

Note: The personal commit name comes from `full_name` in `group_vars/local` (hardcoded), not an env var.

Optional (empty = no passphrase):
```bash
GITHUB_WORK_SSH_PASSPHRASE
GITHUB_PERSONAL_SSH_PASSPHRASE
BITBUCKET_WORK_SSH_PASSPHRASE
```

### Testing

```bash
ssh -T git@github-work    # Should authenticate as work account
ssh -T git@github.com     # Should authenticate as personal account
ssh -T git@bitbucket.org  # Should authenticate as work account
```
