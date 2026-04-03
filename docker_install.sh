#!/bin/bash

# 1. Update the system packages
echo "Updating system..."
sudo yum update -y

# 2. Install Docker 
# Amazon Linux 2023 uses the 'docker' package directly, while AL2 uses 'amazon-linux-extras'
# This command is the most compatible way to fetch the AWS-optimized version
echo "Installing Docker..."
sudo yum install -y docker

# 3. Install Docker Compose (V2)
# The best practice is to install the Compose plugin rather than the old standalone binary
echo "Installing Docker Compose..."
sudo mkdir -p /usr/local/lib/docker/cli-plugins/
# Fetching the latest stable V2 release for Linux x86_64
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# 4. Start and enable the Docker service
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# 5. Apply Best Practice Permissions
# Adding the user to the docker group allows running commands without 'sudo'
echo "Configuring user permissions..."
sudo usermod -aG docker ec2-user

# 6. Finalize
echo "Installation complete. NOTE: Please log out and log back in for group changes to take effect."
echo "Verify with: docker compose version"