#!/bin/bash

# 1. Update system
echo "Updating system..."
dnf update -y

# 2. Install Docker (Amazon Linux repo)
echo "Installing Docker..."
dnf install -y docker

# 3. Start and enable Docker
echo "Starting Docker service..."
systemctl start docker
systemctl enable docker

# 4. Add ec2-user to docker group
echo "Adding ec2-user to docker group..."
usermod -aG docker ec2-user

# 5. Install Docker Compose (standalone binary)
echo "Installing Docker Compose..."
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# 6. Install Docker Buildx (manual plugin)
echo "Installing Docker Buildx..."
mkdir -p /root/.docker/cli-plugins
curl -L https://github.com/docker/buildx/releases/latest/download/buildx-linux-amd64 \
  -o /root/.docker/cli-plugins/docker-buildx
chmod +x /root/.docker/cli-plugins/docker-buildx

# 7. Enable BuildKit
echo "Enabling BuildKit..."
echo 'export DOCKER_BUILDKIT=1' >> /root/.bashrc
export DOCKER_BUILDKIT=1

# 8. Verify installations
echo "Verifying installations..."
docker --version
docker-compose --version

echo "✅ Docker installed successfully! Bootstrapping Application..."

# ==========================================
# 🚀 NEW: ASG APPLICATION BOOTSTRAP PHASE
# ==========================================

# 9. Setup the Application Directory
APP_DIR="/home/ec2-user/flask-nginx-app"
mkdir -p $APP_DIR
cd $APP_DIR

# 10. Dynamically create the docker-compose.yml file
# IMPORTANT: Replace 'yourdockerhubuser' with your actual Docker Hub username!
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  web:
    image: yourdockerhubuser/flask-app:latest
    restart: always
  nginx:
    image: yourdockerhubuser/nginx-proxy:latest
    ports:
      - "80:80"
    depends_on:
      - web
    restart: always
EOF

# Fix ownership so ec2-user can still manage it if you ever use SSM to log in
chown -R ec2-user:ec2-user $APP_DIR

# 11. Pull the latest images and launch the app
echo "Pulling latest Docker images and starting services..."
/usr/local/bin/docker-compose pull
/usr/local/bin/docker-compose up -d

echo "✅ Application deployed and running!"