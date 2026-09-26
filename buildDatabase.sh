#!/bin/bash

set -eu

export LC_ALL=C

if [[ $# -eq 0 ]]; then
  DOWNLOAD_DATE="20260701"
else
  DOWNLOAD_DATE=$1
fi

ROOT_DIR=`pwd`
OUT_DIR="dump"
DOWNLOAD_URL="https://dumps.wikimedia.org/cawiki/$DOWNLOAD_DATE"

SHA1SUM_FILENAME="cawiki-$DOWNLOAD_DATE-sha1sums.txt"
REDIRECTS_FILENAME="cawiki-$DOWNLOAD_DATE-redirect.sql.gz"
PAGES_FILENAME="cawiki-$DOWNLOAD_DATE-page.sql.gz"
LINKTARGET_FILENAME="cawiki-$DOWNLOAD_DATE-linktarget.sql.gz"
LINKS_FILENAME="cawiki-$DOWNLOAD_DATE-pagelinks.sql.gz"

mkdir -p $OUT_DIR

echo "[INFO] Data del Dump: $DOWNLOAD_DATE"
echo "--------------------------------------------------"
echo "📥 PAS 1: Verificant dumps originals..."
echo "--------------------------------------------------"

function download_file() {
  if [ ! -f "$OUT_DIR/$2" ]; then
    echo "[INFO] Descarregant $1..."
    wget --progress=dot:giga "$DOWNLOAD_URL/$2" -O "$OUT_DIR/$2"
  else
    echo "[WARN] El fitxer $1 ja està descarregat. Saltant."
  fi
}

download_file "sha1sums" $SHA1SUM_FILENAME
download_file "redirects" $REDIRECTS_FILENAME
download_file "pages" $PAGES_FILENAME
download_file "linktarget" $LINKTARGET_FILENAME
download_file "links" $LINKS_FILENAME

echo -e "\n--------------------------------------------------"
echo "🐍 PAS 2: Processant SQL directament amb Python i creant SQLite..."
echo "--------------------------------------------------"

rm -f "$ROOT_DIR/sdow.sqlite"

python3 "$ROOT_DIR/process_all_links.py"

echo -e "\n--------------------------------------------------"
echo "📦 PAS 3: Moven la base de dades a la carpeta del projecte..."
echo "--------------------------------------------------"

# Es va col·locar el fitxer de la base de dades en català a dins de la carpeta del projecte amb el nom de “sdow.sqlite” (correspon al nom que busca el programa per defecte).
if [ -f "$OUT_DIR/sdow.sqlite" ]; then
  mv "$OUT_DIR/sdow.sqlite" "$ROOT_DIR/sdow.sqlite"
  echo "[INFO] La base de dades s'ha mogut correctament a $ROOT_DIR/sdow.sqlite"
elif [ -f "$ROOT_DIR/sdow.sqlite" ]; then
  echo "[INFO] El fitxer sdow.sqlite ja es troba a la carpeta arrel del projecte."
fi

echo -e "\n--------------------------------------------------"
echo "🎉 PROCES COMPLETAT AMB ÈXIT!"
echo "--------------------------------------------------"
