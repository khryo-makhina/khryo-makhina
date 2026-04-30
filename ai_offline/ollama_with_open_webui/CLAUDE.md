# Ollama with Open WebUI

Docker Compose stack for running Ollama AI models with Open WebUI frontend. Provides offline AI capabilities with GPU acceleration support.

**Core Components:**
- **Ollama**: Local AI model server with GPU support
- **Open WebUI**: Web-based chat interface for Ollama
- **Proxy**: Custom proxy for enhanced functionality

**Key Features:**
- GPU acceleration for Windows/Linux via NVIDIA drivers
- Customizable model storage path via OLLAMA_MODELS_PATH
- Legacy Docker Compose file as default (compatible with older versions)
- Modern Compose file with device_requests for newer Docker versions
- Local build support for custom entrypoint modifications
- Environment variable configuration for flexible deployment

**Usage:** `docker compose -f docker-compose-ollama-with-open-webui.legacy.yml up -d` to start services (default). Configure model path in `.env` file or via environment variables.

**Purpose:** Enables local, offline AI model hosting with web interface for testing and development.