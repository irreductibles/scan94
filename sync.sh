#!/bin/bash
# Sync scan depuis PRISME principal → repo collegue
SRC="$HOME/Prisme"
DST="$HOME/Downloads/prisme-scan"

cp "$SRC/js/scan.js" "$DST/js/scan.js"
cp "$SRC/js/catalogue-marques.json" "$DST/js/catalogue-marques.json"

cd "$DST"
git add -A
git diff --cached --quiet && echo "Rien a mettre a jour." && exit 0
git commit -m "sync scan $(date +%Y-%m-%d)"
git push
echo "Sync OK"
