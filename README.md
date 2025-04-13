# Home Assistant docker compose based lab (ha-docker)

## Table of Contents
- [Directory Structure](#directory-structure)
- [How to Launch](#how-to-launch)
- [Services](#services)
- [Accessing Services](#accessing-services)
- [Security & Customization](#security--customization)

## Directory Structure
Here's an overview of the files and folders in this repo:

This repository contains a Docker Compose configuration to run a home automation stack including:
- **Traefik** (reverse proxy & TLS/HTTPS certificates)
- **Home Assistant** (main home automation platform)
- **Mosquitto** (MQTT broker)
- **Node-RED** (flows & automation logic)
- **Zigbee2MQTT** (Zigbee bridge via MQTT)
- **Z-Wave JS UI** (Z-Wave bridge & management UI)
- **InfluxDB** (timeseries database)
- **Grafana** (metrics & analytics dashboard)
- **Watchtower** (automatic Docker container updater​)
- **What's Up Docker (WUD)** (web UI for monitoring container updates​)

## Directory Structure

Here's an overview of the files and folders in this repo:

```bash
.
├── data/
│   └── ...                # Persistent data for services
├── docker-compose.yaml    # Docker Compose configuration
├── dot.env                # Environment variables (to be renamed to .env)
├── install.sh             # Setup and initialization script
└── README.md              # This documentation
```


- `data/`: Holds all persistent data for your containers (logs, configs, databases).  
  - For example, `data/homeassistant/config` (Home Assistant configs), `data/influxdb/data` (InfluxDB data), etc.
- `docker-compose.yaml`: The main Docker Compose file describing the services and how they run.
- `dot.env`: The environment variables file (will be renamed to `.env`) used by `docker-compose.yaml`.
- `install.sh`: A helper script that:
  1. Creates missing subfolders in `data/`.
  2. Sets ownership/permissions.
  3. Renames `dot.env` to `.env` (if `.env` doesn’t exist already).
  4. Launches `docker compose up -d`.

## How to Launch

1. **Clone or copy** this repository:

   ```bash
   git clone https://github.com/Oakwhistle/ha-docker.git
   cd ha-docker
   ```

2. **Review and edit** `dot.env`:

   - Set your time zone, domain, credentials, etc.
   - Update any paths or device settings to match your hardware.

3. **Run the install script**:

   ```bash
   chmod +x create-certs.sh # Execute for local environments
   chmod +x install.sh
   ./create-certs.sh
   ./install.sh
   ```
   - This scripts will create self signed certificates, subdirectories under ./data, rename dot.env to .env, adjust permissions, and start the containers.

4. **Verify everything is running**:
   
   ```bash
   docker ps
   docker compose ps

   # Tail container's log
   docker logs -tf <container-name-or-id>

   # Stop containers
   docker compose down

   # Destroy environment and data (be careful)
   docker compose down -v
   ```
   - You should see all the services up and running.

5. **Backup your data**:
   
   ```bash
   chmod +x backup-data.sh
   ./backup-data.sh
   ```

## Services:

- Traefik terminates HTTPS requests on ports 80 (HTTP) and 443 (HTTPS). It uses Let’s Encrypt (staging by default) to issue SSL certificates.
- Home Assistant listens internally on port 8123, but is accessible via https://homeassistant.<your-domain> through Traefik.
- Mosquitto is published on port 1883 for LAN MQTT use. It doesn’t expose a web interface.
- Node-RED is available via https://nodered.<your-domain> (internally on port 1880).
- Zigbee2MQTT provides a Zigbee <-> MQTT bridge, accessible at https://zigbee2mqtt.<your-domain> (internally on port 8080).
- Z-Wave JS UI provides a Z-Wave <-> MQTT or Z-Wave JS environment, accessible at https://zwavejsui.<your-domain> (internally on port 8091).
- InfluxDB is available via https://influxdb.<your-domain> (internally on port 8086).
- Grafana is available via https://grafana.<your-domain> (internally on port 3000).

## Lets Encrypt:

To use this feature switch the following comments at `docker-compose.yaml` and restart the container (ie: `docker compose up -d --force-recreate`):

```yaml
#############################################################
# Option A: Use Let's Encrypt (commented out in this example)
#############################################################
# - "--certificatesresolvers.myresolver.acme.httpchallenge=true"
# - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
# - "--certificatesresolvers.myresolver.acme.email=${LETSENCRYPT_EMAIL}"
# - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
# - "--certificatesresolvers.myresolver.acme.caserver=${ACME_CA_SERVER}"
#############################################################
# Option B: Use Self-Signed Certificates (enabled below)
#############################################################
- "--entrypoints.websecure.http.tls=true"
- "--entrypoints.websecure.http.tls.certresolver="  # Leave empty for manual TLS
- "--entrypoints.websecure.http.tls.certificates[0].certFile=/certs/cert.pem"
- "--entrypoints.websecure.http.tls.certificates[0].keyFile=/certs/key.pem"
```

> Note: this will only work when using a public domain. 

## Accessing Services:

| Service            | URL                                   | Internal Port |
| ------------------ | ------------------------------------- | ------------- |
| Traefik Dashboard  | https://traefik.yourdomain.com         | 8080          |
| Home Assistant     | https://homeassistant.yourdomain.com   | 8123          |
| Node-RED           | https://nodered.yourdomain.com         | 1880          |
| Zigbee2MQTT        | https://zigbee2mqtt.yourdomain.com     | 8080          |
| Z-Wave JS UI       | https://zwavejsui.yourdomain.com       | 8091          |
| InfluxDB           | https://influxdb.yourdomain.com        | 8086          |
| Grafana            | https://grafana.yourdomain.com         | 3000          |
| What's Up Docker   | https://wud.yourdomain.com             | 3000          |

## Security & Customization

- Update dot.env (which becomes .env) to set strong passwords for InfluxDB, unique session secrets for Z-Wave JS UI, and any other credentials.
- For production SSL certificates, replace the staging ACME server with the official Let’s Encrypt URL in .env.
- Customize user permissions or ownership to your needs in the install.sh script.