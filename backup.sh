#!/bin/bash
# Practica 2 - Script de backup con TAR
# Comprime la carpeta /home/<usuario> en un archivo con la fecha y hora
# actual en formato dd-mm-yyyy:hh:mm

FECHA=$(date +%d-%m-%Y:%H:%M)
DESTINO="$HOME/backups"
ARCHIVO="$DESTINO/backup_$FECHA.tar.gz"

mkdir -p "$DESTINO"

# --force-local: evita que tar interprete los ":" del nombre como un host remoto
# --exclude: evita que el backup se incluya dentro de si mismo
tar --force-local -czf "$ARCHIVO" --exclude="$USER/backups" -C /home "$USER"

echo "Backup creado: $ARCHIVO"
