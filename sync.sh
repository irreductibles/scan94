#!/bin/bash
# Sync scan depuis PRISME principal → repo collegue
SRC="$HOME/Prisme"
DST="$HOME/prisme-scan94"

cp "$SRC/js/scan.js" "$DST/js/scan.js"
cp "$SRC/js/catalogue-marques.json" "$DST/js/catalogue-marques.json"
cp "$SRC/scan.html" "$DST/index.html"

# Generer index.json pour lister les fichiers data/
if [ -d "$DST/data" ]; then
  (cd "$DST/data" && ls -1 *.json 2>/dev/null | grep -v index.json | python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))" > index.json)
fi

# Cache-bust auto : maj version dans index.html
V="v=$(date +%Y%m%d%H%M)"
sed -i '' "s|js/scan.js?v=[^\"]*|js/scan.js?$V|" "$DST/index.html"

cd "$DST"
git pull --rebase 2>/dev/null
git add -A
git diff --cached --quiet && echo "Rien a mettre a jour." && exit 0
git commit -m "sync scan $(date +%Y-%m-%d)"
git push && echo "Sync OK" || echo "ERREUR: push échoué, relancer sync.sh"
