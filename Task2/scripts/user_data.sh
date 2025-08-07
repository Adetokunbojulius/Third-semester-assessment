

#!/bin/bash
set -e

# Update packages and install core tools
sudo apt update -y
sudo apt install -y snapd

# Wait for cloud-init and snap to be ready
sleep 10

# Install the SSM Agent via snap (only if not already present)
if ! sudo systemctl status amazon-ssm-agent >/dev/null 2>&1; then
    sudo snap install amazon-ssm-agent --classic
fi

# Start and enable the SSM agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent