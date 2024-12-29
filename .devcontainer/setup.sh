#!/bin/bash
set -e

# Install OpenTofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm -f install-opentofu.sh

# Install kubectl
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Install k9s
curl -LO https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_linux_amd64.deb
sudo apt install -y ./k9s_linux_amd64.deb
rm -f k9s_linux_amd64.deb
