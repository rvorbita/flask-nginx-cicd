#!/bin/bash

# 1. Update system
echo "Updating system..."
sudo dnf update -y

# 2. Install Docker (Amazon Linux repo)
echo "Installing Docker..."
sudo dnf install -y docker

# 3. Start and enable Docker
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# 4. Add ec2-user to docker group
echo "Adding ec2-user to docker group..."
sudo usermod -aG docker ec2-user

# 5. Install Docker Compose (standalone binary)
echo "Installing Docker Compose..."
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# 6. Install Docker Buildx (manual plugin)
echo "Installing Docker Buildx..."
mkdir -p ~/.docker/cli-plugins

curl -L https://github.com/docker/buildx/releases/latest/download/buildx-linux-amd64 \
  -o ~/.docker/cli-plugins/docker-buildx

chmod +x ~/.docker/cli-plugins/docker-buildx

# 7. Enable BuildKit
echo "Enabling BuildKit..."
echo 'export DOCKER_BUILDKIT=1' >> ~/.bashrc
export DOCKER_BUILDKIT=1

# 8. Verify installations
echo "Verifying installations..."
docker --version
docker-compose --version
docker buildx version

echo "✅ Docker, Buildx, and Docker Compose installed successfully!"