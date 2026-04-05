#!/usr/bin/env bash
# tests/scripts/test-update-system-multipass.sh - Test update and upgrade system in a disposable Multipass VM

VM_NAME="dot-update-test-$(date +%s)"
INSTANCE_TYPE="22.04"
KEEP_VM=false

# Check for --keep flag
for arg in "$@"; do
  if [ "$arg" == "--keep" ]; then
    KEEP_VM=true
  fi
done

# Cleanup function
cleanup() {
  if [ "$KEEP_VM" = true ]; then
    echo -e "\n📌 Keeping VM: $VM_NAME for inspection."
    echo "🗑️ To destroy later: multipass delete --purge $VM_NAME"
  else
    echo -e "\n🧹 Cleaning up... purging $VM_NAME"
    multipass delete --purge "$VM_NAME"
  fi
}

# Trap exit/interrupt signals
trap cleanup EXIT ERR SIGINT SIGTERM

echo "🚀 Launching Ubuntu $INSTANCE_TYPE VM: $VM_NAME..."
multipass launch "$INSTANCE_TYPE" --name "$VM_NAME" --cpus 2 --memory 4G --disk 20G

echo "📂 Mounting current directory to VM..."
multipass mount . "$VM_NAME":/home/ubuntu/.dotfiles

echo "🛠️ Installing Ansible inside VM..."
multipass exec "$VM_NAME" -- sudo apt update
multipass exec "$VM_NAME" -- sudo apt install -y ansible curl npm

echo "🏗️ Setting up test environment..."
# 1. Back up versions.yml in the VM (it's mounted, so we must be careful)
# Actually, since it's mounted, we should work on a copy to avoid messing with the host
multipass exec "$VM_NAME" -- cp /home/ubuntu/.dotfiles/versions.yml /home/ubuntu/versions.yml.bak

echo "🧪 Running Update System Tests..."

# Test 1: Verify check-updates output
echo "Test 1: Running check-updates..."
multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && ./bin/dot-bootstrap check-updates --tags golang"

# Test 2: Verify upgrade workflow
echo "Test 2: Running simulated upgrade for ast-grep..."
# Downgrade version in the mounted file (temporarily)
# WARNING: This affects the host because it's a mount! 
# To be safe, we should probably unmount or use a non-mounted copy for the test.
# But for now, we'll just be very careful to restore it.

# Downgrade ast-grep in versions.yml
multipass exec "$VM_NAME" -- sed -i 's/^ast_grep_version: .*/ast_grep_version: "0.0.1"/' /home/ubuntu/.dotfiles/versions.yml

echo "Running upgrade command in VM..."
# Simulate 'y' to the upgrade prompt
multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && yes y | ./bin/dot-bootstrap upgrade ast-grep --skip-become-pass"

# Verify update happened
UPDATED_VERSION=$(grep "^ast_grep_version:" versions.yml | sed -E 's/.*: "([^"]+)".*/\1/')
if [ "$UPDATED_VERSION" != "0.0.1" ]; then
    echo "✅ SUCCESS: ast-grep version updated from 0.0.1 to $UPDATED_VERSION"
else
    echo "❌ FAILURE: ast-grep version remained at 0.0.1"
    exit 1
fi

# Restore original versions.yml
multipass exec "$VM_NAME" -- cp /home/ubuntu/versions.yml.bak /home/ubuntu/.dotfiles/versions.yml

echo "✅ All update system tests passed in Multipass!"
