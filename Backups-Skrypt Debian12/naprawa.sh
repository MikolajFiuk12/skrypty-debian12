#!/bin/bash

clear

echo "==============================="
echo "  MENU"
echo "==============================="
echo "1) Pokaż komendy do uruchomienia backup.sh"
echo "0) Wyjście"
echo "==============================="
echo
read -p "Wybierz opcję: " opcja

case $opcja in
  1)
    clear
    echo "Skopiuj poniższe komendy:"
    echo
    echo "apt install -y dos2unix"
    echo "dos2unix backup.sh"
    echo "chmod +x backup.sh"
    echo "./backup.sh"
    echo
    ;;
  0)
    exit 0
    ;;
  *)
    echo "Nieprawidłowa opcja"
    ;;
esac
