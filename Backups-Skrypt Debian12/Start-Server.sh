#!/bin/bash

echo "🚀 Startuję wszystko..."
echo ""

start_screen () {
  NAME=$1
  CMD=$2

  echo "➡️ Start screena: $NAME"

  # usuń stary jeśli istnieje
  if screen -list | grep -q "$NAME"; then
    echo "⚠️ Usuwam stary screen: $NAME"
    screen -S "$NAME" -X quit
    sleep 1
  fi

  # uruchom screen NORMALNIE (z konsolą)
  screen -S "$NAME" bash -c "cd .. && $CMD"
}

# START
start_screen "mc" "./server"
start_screen "backup" "./backups.sh"
start_screen "eq" "./equ.sh"

echo ""
echo "📊 Screeny:"
screen -ls

echo ""
echo "👉 Wejdź do konsoli np:"
echo "screen -r mc"