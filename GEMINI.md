# Gemini Project Policies & Mandates

This file contains foundational mandates for AI agents working on this repository. These instructions take absolute precedence over general workflows.

## Engineering Standards

### 1. Atomic Extractions (Clean Install Policy)
When installing tools via archive (tar/zip) into a system directory (e.g., `/usr/local/go`), you **MUST** ensure the target directory is completely removed (`state: absent`) before extraction. This prevents "ghost" file corruption where files from older versions remain and conflict with the new installation.

### 2. Version Locking
All external binary tools and languages **MUST** have their versions locked in `versions.yml`. 
- Do not use "latest" or hardcoded version strings in task files.
- New tools must be added to `versions.yml` and integrated into `update-check.yml`.

### 3. Verified Compiles
A tool installation is not verified by a simple `--version` check.
- For compilers and runtimes (Go, Python, Node), you **MUST** create, compile, and execute a "Hello World" program in the target environment to confirm the internal integrity of the standard library and ABI.

### 4. Git Staging Precision
When committing changes, avoid `git add .` or broad patterns. 
- Use surgical staging (individual files or `git add -p`) to ensure unrelated changes (like local `TODO.md` updates or temporary test files) are not accidentally committed.
- Review `git diff --staged` before every commit.

## Testing Standards

### 1. Multipass for Ubuntu
All Ubuntu-specific changes **MUST** be verified in a clean Multipass VM using the `tests/scripts/test-ubuntu.sh` script (or specialized variants) to ensure the host environment is not polluted and the instructions are truly portable.
