---
name: install-net9-runtime
description: Install the .NET 9 runtime semi-automatically for supported Windows end-user machines.
argument-hint: "[--yes]"
disable-model-invocation: true
---

Run `install-net9-runtime.ps1` to download and install the .NET 9 runtime if it is not already present.

Use this command on end-user machines that will run the self-contained bundles or the published .NET 9 apps.

Examples:
- `install-net9-runtime` — check for .NET 9 and install it if needed
- `install-net9-runtime --yes` — install without interactive confirmation when possible
