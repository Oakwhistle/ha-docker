# Home Assistant docker compose based lab (ha-docker)

## Data Folder Structure

Under the ./data directory (once created), you’ll see something like:

```bash
data/
├── homeassistant/
│   └── config/
├── mosquitto/
│   └── data/
├── nodered/
│   └── data/
├── zigbee2mqtt/
│   └── data/
├── zwavejsui/
│   └── data/
├── influxdb/
│   ├── data/
│   └── config/
├── grafana/
│   └── data/
├── wud/
│   └── data/
└── traefik/
    └── letsencrypt/
```

Each subfolder corresponds to a Docker volume bind-mount, ensuring any container restarts or updates won’t erase your data.

