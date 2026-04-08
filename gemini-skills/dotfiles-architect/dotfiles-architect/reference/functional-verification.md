# Functional Verification Pattern

A simple version check (`--version`) is not enough to verify a successful installation of a compiler or runtime. You must ensure the environment's integrity by executing a test program.

## Requirements
- Create a temporary source file.
- Compile and/or execute the file using the target tool.
- Verify the output matches the expected result.
- Clean up the temporary file.

## Ansible Implementation
```yaml
- name: Verify compilation and execution
  command: /usr/local/go/bin/go run /tmp/verify_go.go
  register: verify_output
  failed_when: verify_output.stdout != "OK"
```
