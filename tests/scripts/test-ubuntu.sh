#!/usr/bin/env bash
# scripts/test-ubuntu.sh - Test dotfiles in a disposable Multipass VM

VM_NAME="dotfiles-test-$(date +%s)"
INSTANCE_TYPE="22.04" # Use your target Ubuntu version

echo "🚀 Launching Ubuntu $INSTANCE_TYPE VM: $VM_NAME..."
multipass launch "$INSTANCE_TYPE" --name "$VM_NAME" --cpus 2 --memory 4G --disk 10G

echo "📂 Mounting current directory to VM..."
multipass mount . "$VM_NAME":/home/ubuntu/.dotfiles

echo "🛠️ Installing Ansible inside VM..."
multipass exec "$VM_NAME" -- sudo apt update
multipass exec "$VM_NAME" -- sudo apt install -y ansible

echo "🏗️ Running dotfiles bootstrap..."
multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && ./bin/dot-bootstrap \"$tags\" --skip-become-pass"

echo "🧪 Running verification tasks..."
multipass exec "$VM_NAME" -- bash -c "cd ~/.dotfiles && ansible-playbook -i localhost, tests/verify-all.yml"

echo "✅ Done! To access the VM: multipass shell $VM_NAME"
echo "🗑️ To destroy: multipass delete --purge $VM_NAME"
