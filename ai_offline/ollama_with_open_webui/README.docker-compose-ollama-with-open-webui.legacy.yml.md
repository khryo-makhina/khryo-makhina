# README for docker-compose-ollama-with-open-webui.legacy.yml

Run / Start — legacy Compose commands for `docker-compose-ollama-with-open-webui.legacy.yml` (copy-paste):

```bash
# Start (legacy compose file — recommended for older Compose)
docker compose -f docker-compose-ollama-with-open-webui.legacy.yml up -d

# Start (build local Dockerfile first)
docker compose -f docker-compose-ollama-with-open-webui.legacy.yml up -d --build

# Stop and remove containers
docker compose -f docker-compose-ollama-with-open-webui.legacy.yml down

# Remove volumes and images (clean)
docker compose -f docker-compose-ollama-with-open-webui.legacy.yml down -v --rmi all
```

Compatibility note:
- Use this legacy file if your `docker compose` rejects `deploy.resources.reservations.devices` (older Compose versions).
- If you have Docker Compose V2 with `deploy.resources.reservations.devices` support, prefer the modern file (`docker-compose-ollama-with-open-webui.yml`).
