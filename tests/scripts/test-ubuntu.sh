#!/usr/bin/env bash
# scripts/test-ubuntu.sh - Test dotfiles in a disposable Multipass VM

VM_NAME="dotfiles-test-$(date +%s)"
INSTANCE_TYPE="22.04" # Use your target Ubuntu version
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
multipass exec "$VM_NAME" -- sudo apt install -y ansible

echo "🏗️ Running dotfiles bootstrap..."
# Use all if tags is not set
run_tags="${tags:-all}"
multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && ./bin/dot-bootstrap \"$run_tags\" --skip-become-pass"

echo "🧪 Running verification tasks..."
# If tags are provided, only run those verification tasks
if [ -n "$tags" ]; then
  # verification tag is always needed to run the tasks in verify-all.yml
  multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && ansible-playbook -i localhost, tests/verify-all.yml --tags \"$tags,verification\""
else
  multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && ansible-playbook -i localhost, tests/verify-all.yml"
fi

echo "✅ Done! To access the VM (if --keep was used): multipass shell $VM_NAME"
