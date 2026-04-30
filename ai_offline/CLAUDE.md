# ai_offline: Offline AI Experiments

This directory contains experiments with locally-hosted AI models and tools. No cloud dependencies, all models run on local hardware.

**Subdirectories:**
- **ollama_with_open_webui/**: Docker Compose stack for Ollama + Open WebUI (see its CLAUDE.md)

**Related:** The translations_csv/OllamaTranslatorApi project integrates with Ollama for offline translation.

## Ollama Setup for Claude Code

See `ollama_integrations_claude-code.md` for:
- Installing Ollama on Windows
- Compatible models for local hardware (ministral-3, qwen3.5, glm-4.7-flash)
- Launching Claude Code with offline models: `ollama launch claude --model qwen3.5:9b`

## Hardware Requirements

Local setup tested on:
- RTX 3060 12 GB VRAM
- 100 GB RAM DDR3
- Dual Xeon E5-2690 v2 (20 cores, 40 threads)

Smaller models (7B-14B parameters) work well with this configuration.

## Usage

Navigate to subdirectories for specific projects. This level is organizational only.
