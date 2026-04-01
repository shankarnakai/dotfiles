# Decision Log: Testing Framework Choice

## Context
The goal of this project is to adapt a macOS-centric dotfiles repository (using Ansible) to work seamlessly on Ubuntu while maintaining macOS compatibility. A disposable, repeatable testing environment is required to avoid polluting the host machine.

## Decision
**We have chosen a custom testing stack (Multipass, Tart, and GitHub Actions) over Molecule.**

### Why Not Molecule?
1. **High Setup Overhead:** Molecule requires a `molecule/` directory with multiple configuration files for *each* of the 20+ roles. This creates significant maintenance debt for a personal project.
2. **Poor macOS Support:** Molecule is primarily designed for Linux/Docker testing. Testing macOS locally on Ubuntu is not possible with Molecule, and setting up macOS Vagrant boxes is slow and fragile.
3. **Isolation vs. Integration:** Molecule tests roles in a vacuum. Dotfiles are highly interdependent (e.g., `nvim` depends on `git`, `python`, and `node`). A full "Bootstrap" test in a VM is more realistic than 20 isolated role tests.
4. **Statelessness:** Molecule destroys the environment after every test. For personal dotfiles, an "Iterative VM" (Multipass/Tart) allows for faster "tweak-and-run" cycles without a full rebuild.

### Why Multipass + Tart + GitHub Actions?
1. **System-Level Testing:** Both Multipass (Ubuntu) and Tart (macOS) provide a real `systemd` / `launchd` environment and real user sessions, which are critical for testing shell changes and background services.
2. **Speed:** Multipass and Tart use native hypervisors (KVM/Hyper-V/Virtualization.framework), making them the fastest way to get a clean VM.
3. **CI/CD Assurance:** GitHub Actions provides free, clean runners for both Ubuntu and macOS, serving as the "final exam" for any change pushed to the repository.
