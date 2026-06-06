#!/usr/bin/env bash
# Fast APK build — requires spicylooper-builder image (run build-builder.sh first).
set -euo pipefail

if ! docker image inspect spicylooper-builder &>/dev/null; then
  echo ">>> Builder image not found. Run ./build-builder.sh first."
  exit 1
fi

mkdir -p output

echo ">>> Building APK…"
docker build -t spicylooper-apk -f Dockerfile.apk .
docker run --rm -v "$(pwd)/output":/output spicylooper-apk

echo ">>> Done!  output/SpicyLooper-debug.apk"
