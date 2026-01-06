#!/bin/bash

set -e

echo "🔧 Starting DevOps tools installation..."

# Update system
sudo apt update -y

# Install Docker
if command -v docker &> /dev/null
then
    echo "✅ Docker already installed"
else
    echo "🐳 Installing Docker..."
    sudo apt install -y ca-certificates curl gnupg lsb-release

    curl -fsSL https://get.docker.com | sudo sh

    sudo usermod -aG docker $USER
    echo "⚠️ Docker installed. Logout/login to apply docker group."
fi

# Install Docker Compose
if command -v docker-compose &> /dev/null
then
    echo "✅ Docker Compose already installed"
else
    echo "🐙 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose
fi

# Install Python 3 and pip
if command -v python3 &> /dev/null
then
    PY_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    echo "✅ Python $PY_VERSION already installed"
else
    echo "🐍 Installing Python..."
    sudo apt install -y python3 python3-pip python3-venv
fi

if ! python3 -m pip --version &> /dev/null
then
    sudo apt install -y python3-pip
fi

# Install Django
if python3 -m django --version &> /dev/null
then
    echo "✅ Django already installed"
else
    echo "🌐 Installing Django..."
    python3 -m pip install --break-system-packages --user django
fi

echo "🎉 Installation completed successfully!"
