## Ollama
> Ollama is a platform that allows users to run large language models (LLMs) locally on their own computers, providing privacy, speed, and flexibility without relying on cloud services.

[Download Ollama](https://ollama.com/download)
> Ollama is available on macOS, Windows, and Linux.

## Anthropic's Claude Code
URL: https://docs.ollama.com/integrations/claude-code
> Claude Code is Anthropic’s agentic coding tool that can read, modify, and execute code in your working directory.

Install [Claude Code](https://code.claude.com/docs/en/overview):
> Claude Code is an agentic coding tool that reads your codebase, edits files, runs commands, and integrates with your development tools. Available in your terminal, IDE, desktop app, and browser.

Windows
```text
irm https://claude.ai/install.ps1 | iex
```

## Ollama offline/non-cloud models models compatible with Claude Code

For hardware (RTX 3060 12 GB VRAM, 96 GB RAM DDR3, dual Xeon E5‑2690 v2 (CPU Mark: Multithread Rating: 13290, Single Thread Rating: 1857, Cores: 10, Threads:20), dual: (Cores: 2x10=20, Threads:2x20 = 40))

### ministral-3
```text
ollama pull ministral-3:14b
ollama launch claude --model ministral-3:14b
```

### qwen3.5

URL: https://ollama.com/library/qwen3.5
```text
ollama pull qwen3.5:9b
ollama launch claude --model qwen3.5:9b
```

### glm-4.7-flash
URL: https://ollama.com/library/glm-4.7-flash
```text
ollama pull glm-4.7-flash:q4_K_M
ollama launch claude --model glm-4.7-flash:q4_K_M
```
