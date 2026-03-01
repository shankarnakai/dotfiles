---
name: shell-script-helper
description: >
  Workflow for creating and modifying shell scripts (bash, zsh, sh) with mandatory
  shellcheck validation. Use this skill whenever creating a new shell script, editing
  an existing .sh/.zsh file, modifying files in bin/ or roles/zsh/, working on
  dotfiles shell configuration, or when the user mentions shellcheck, shell linting,
  or bash scripting. Also trigger when editing any file that starts with a shebang
  (#!/bin/bash, #!/bin/sh, #!/usr/bin/env bash, #!/bin/zsh).
---

# Shell Script Helper

A workflow for writing and modifying shell scripts that ensures every change is
validated with shellcheck before considering the task complete. The goal is to catch
common pitfalls — quoting issues, undefined variables, portability problems — before
they cause real trouble.

## Workflow

### 1. Understand the Script

Before making changes, read the entire file to understand:

- **Shell dialect**: Check the shebang line (`#!/bin/bash`, `#!/bin/sh`, `#!/bin/zsh`, `#!/usr/bin/env bash`). This determines which shellcheck dialect to use.
- **What the script does**: Understand the purpose so changes don't break existing behavior.
- **Sourced files**: Note any `source` or `.` commands — these affect variable scope and shellcheck findings.

If creating a new script:
- Always include a shebang line. Default to `#!/usr/bin/env bash` for portability unless there's a reason to use something else.
- Make it executable: `chmod +x <file>`.

### 2. Make the Changes

Write clean, idiomatic shell code:

- Quote variables: `"$var"` not `$var` (unless intentionally word-splitting).
- Use `[[ ]]` over `[ ]` in bash/zsh for conditionals — it handles empty strings and pattern matching more safely.
- Prefer `$()` over backticks for command substitution.
- Use `set -euo pipefail` at the top of bash scripts when appropriate (it makes scripts fail fast on errors, undefined variables, and pipe failures).
- For zsh scripts, remember that arrays are 1-indexed and `${var}` behaves differently than in bash.

### 3. Run shellcheck (mandatory)

After every modification, run shellcheck on the file. This is not optional — always validate before finishing.

**Detect the shell type and choose flags automatically:**

For **bash/sh scripts** (shebang contains `bash` or `sh`):
```bash
shellcheck -s bash <file>
```

For **zsh files** (`.zsh` extension, or shebang contains `zsh`, or files in `roles/zsh/`):
```bash
shellcheck -s bash --exclude=SC1091,SC2034 <file>
```
Zsh exclusions explained:
- SC1091: "Not following sourced file" — shellcheck can't resolve zsh source paths, especially oh-my-zsh plugins.
- SC2034: "Variable appears unused" — zsh frameworks like oh-my-zsh use variables (`ZSH_THEME`, `plugins`, etc.) that shellcheck can't see being consumed.

For **files without a clear shebang** (e.g., sourced config fragments):
- If the file is in `roles/zsh/` or has a `.zsh` extension, treat it as zsh.
- Otherwise, default to `shellcheck -s bash`.

### 4. Fix All Warnings

If shellcheck reports issues:

1. Fix each warning. Most common ones:
   - **SC2086** (unquoted variable): Add double quotes around `$variable`.
   - **SC2046** (unquoted command substitution): Quote `"$(command)"`.
   - **SC2162** (`read` without `-r`): Use `read -r` to prevent backslash interpretation.
   - **SC2148** (missing shebang): Add `#!/usr/bin/env bash` at the top.
   - **SC2155** (declare and assign separately): Split `local var=$(cmd)` into `local var; var=$(cmd)`.

2. Re-run shellcheck after fixes to confirm they're clean.

3. If a warning is a genuine false positive for the specific context, suppress it with an inline directive right above the offending line:
   ```bash
   # shellcheck disable=SC2034
   MY_VAR="used by external framework"
   ```
   Always add a comment explaining why the suppression is justified. Do not blanket-disable warnings — suppress only the specific code on the specific line.

### 5. Confirm Completion

The task is done only when shellcheck exits with no warnings (exit code 0). If there are remaining warnings that cannot be fixed, explain each one to the user and get their approval before considering the task complete.

## Zsh Function Gotchas

When editing zsh functions in `roles/zsh/functions.zsh` or `roles/zsh/functions/`:

- **`[ ]` vs `[[ ]]`**: `[ "$x" == "y" ]` fails in zsh with `= not found`. Always use `[[ "$x" == "y" ]]` in zsh files.
- **Error return codes**: Error paths in functions must `return 1` explicitly — don't let them fall through with an implicit 0.
- **File layout**: `roles/zsh/functions/` contains standalone files; `_`-prefixed files are zsh completions (loaded via `fpath`), others are sourced at shell startup by `functions.zsh`.
- **Testing functions**: Validate interactively with `zsh -i -c 'funcname args; echo "exit: $?"'`

## Quick Reference: Shell Detection

| Signal | Dialect | Shellcheck flags |
|---|---|---|
| `#!/bin/bash` or `#!/usr/bin/env bash` | bash | `-s bash` |
| `#!/bin/sh` | POSIX sh | `-s sh` |
| `#!/bin/zsh` or `#!/usr/bin/env zsh` | zsh | `-s bash --exclude=SC1091,SC2034` |
| `.zsh` extension | zsh | `-s bash --exclude=SC1091,SC2034` |
| File in `roles/zsh/` | zsh | `-s bash --exclude=SC1091,SC2034` |
| No shebang, no extension | bash (default) | `-s bash` |
