#!/usr/bin/env bash
# Usage: ./make_spl.sh <project-dir>
# Creates <project-dir>.spl from a directory containing:
#   intro.mp3/.wav   end.mp3/.wav   a.mp3/.wav   b.mp3/.wav   c.mp3/.wav   d.mp3/.wav
#   cover.jpg/.png   (optional)
set -euo pipefail

DIR="${1:?Usage: $0 <project-dir>}"
DIR="${DIR%/}"   # strip trailing slash
OUT="${DIR}.spl"

[ -d "$DIR" ] || { echo "Not a directory: $DIR"; exit 1; }

(cd "$DIR" && zip -j "../$(basename "$OUT")" *)
echo "Created: $OUT"
