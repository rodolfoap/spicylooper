#!/usr/bin/env bash
# Run this ONCE (or when package.json / capacitor.config.json change).
# Installs Android SDK, Node packages, and pre-warms Gradle — takes ~15 min.
set -euo pipefail

echo ">>> Building spicylooper-builder image (this will take a while)…"
docker build -t spicylooper-builder -f Dockerfile.builder .
echo ">>> Done. Run ./build-apk.sh for all future APK builds."
