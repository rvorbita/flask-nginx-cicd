#!/bin/bash

# 1. Update system packages
echo "Updating system..."
sudo dnf update -y

# 2. Remove any old/incorrect Docker repos to avoid conflicts
sudo rm -f /etc/yum.repos.d/docker-ce.repo
sudo dnf clean all
sudo dnf makecache

# 3. Install Docker + Buildx + Compose plugin (native AL2023 packages)
echo "Installing Docker, Buildx, and Docker Compose plugin..."
sudo dnf install -y docker docker-buildx-plugin docker-compose-plugin

# 4. Start and enable Docker service
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable --now docker

# 5. Configure user permissions
echo "Adding ec2-user to docker group..."
sudo usermod -aG docker ec2-user
newgrp docker

# 6. Optional: Enable BuildKit for faster builds
echo "Enabling Docker BuildKit..."
echo 'export DOCKER_BUILDKIT=1' >> /home/ec2-user/.bashrc
export DOCKER_BUILDKIT=1

# 7. Verify installations
echo "Installation complete. Verify with:"
docker --version
docker buildx version
docker compose version

echo "Docker, Buildx, and Docker Compose plugin have been installed successfully!"

