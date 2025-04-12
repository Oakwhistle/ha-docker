#!/usr/bin/env bash
#
# install.sh
#
# A simple script to prepare directories, set permissions, rename dot.env to .env,
# and bring the Docker stack up.

set -e  # Exit on error

# 1) Create the directory structure under ./data
echo "Creating data subdirectories..."

mkdir -p data/traefik/letsencrypt
mkdir -p data/homeassistant/config
mkdir -p data/mosquitto/data
mkdir -p data/nodered/data
mkdir -p data/zigbee2mqtt/data
mkdir -p data/zwavejsui/data
mkdir -p data/influxdb/data
mkdir -p data/influxdb/config
mkdir -p data/grafana/data
mkdir -p data/wud/data

echo "Directory structure created."

# 2) Ensure correct ownership/permissions
#    Adjust as needed; here we assume the current user can own the data directory
#    on Ubuntu. If you want root, change to root:root, etc.
# echo "Setting permissions..."
# sudo chown -R "$(whoami):$(whoami)" data/
# sudo chmod -R 755 data/
# echo "Permissions set."

# 3) Rename dot.env to .env (only if .env doesn't already exist)
if [[ -f ".env" ]]; then
  echo "Warning: .env already exists. Skipping rename."
else
  if [[ -f "dot.env" ]]; then
    mv dot.env .env
    echo "Renamed dot.env to .env."
  else
    echo "No dot.env file found. Please ensure your environment file is named correctly."
  fi
fi

# 4) Run docker compose up -d
echo "Starting Docker containers..."
docker compose up -d

echo "Done! Your stack should now be running."
