#!/bin/bash
# Practica 2 - Script que guarda la salida de ifconfig en el escritorio
# Pregunta el nombre del archivo y lo crea con el nombre indicado

read -p "Que nombre desea ponerle al archivo? " NOMBRE

ESCRITORIO="$HOME/Escritorio"
[ -d "$HOME/Desktop" ] && ESCRITORIO="$HOME/Desktop"
mkdir -p "$ESCRITORIO"

ifconfig > "$ESCRITORIO/$NOMBRE.txt"

echo "Archivo creado: $ESCRITORIO/$NOMBRE.txt"
