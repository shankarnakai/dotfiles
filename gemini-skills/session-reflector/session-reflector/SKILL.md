---
name: session-reflector
description: Analyzes the current session to identify optimization opportunities for project policies, skills, and tools. Use when the user asks to "reflect on the session," "improve the workflow," or when a task is completed and a summary is needed.
---

# Session Reflector

This skill guides you through a formal "Reflection & Optimization" phase. It is not just about summarizing; it's about evolving the project's engineering standards.

## Workflow: The Reflection Loop

When triggered, perform these steps in order:

### 1. Identify Patterns
Analyze the conversation history, git log, and file diffs to find:
- **Success Patterns:** What worked exceptionally well? (e.g., automated Multipass tests).
- **Friction Patterns:** Where did we struggle? (e.g., `sudo` timeouts, merge conflicts).
- **Antipatterns:** What habits should we change? (e.g., extracting archives over existing folders).
- **Boilerplate:** What tasks did we repeat manually? (e.g., setting up `lookup_version.yml`).

### 2. Propose Evolutions
Based on the patterns, propose improvements in these categories:
- **Policies (`GEMINI.md`):** New mandates to prevent recurring errors.
- **Skills:** New specialized skills or updates to existing ones to automate boilerplate.
- **Commands:** New shell scripts (e.g., `bin/dot-test`) to simplify complex workflows.
- **Project Structure:** Improvements to how files are organized or versions are managed.

### 3. Execution
If the user approves, immediately:
- Update/Create `GEMINI.md` with new mandates.
- Scaffold new scripts or skills.
- Log remaining tasks to `TODO.md` or GitHub Issues.

## Common Optimization Targets

- **Permission Handling:** Improving how `sudo` and `become` are used to minimize interactive prompts.
- **Atomic Operations:** Ensuring installations are clean and idempotent.
- **Automated Verification:** Moving from manual checks to integrated test scripts.
- **Git Hygiene:** Improving staging precision and commit message quality.

## Examples

**User:** "We just fixed that Go bug. Anything we can learn from it?"
**Reflector:** "Yes. The bug was caused by an 'unarchive' overwrite. I propose adding an 'Atomic Extraction' mandate to `GEMINI.md` and a 'Verified Compile' check to all compiler roles."

**User:** "Reflect on this session's efficiency."
**Reflector:** "We spent 20% of the session setting up Multipass VMs. I suggest creating a `bin/dot-test` script to automate this boilerplate."
