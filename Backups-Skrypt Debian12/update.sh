#!/usr/bin/env bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo "Sprawdzanie aktualizacji pakietów..."
sleep 1
echo "Pobieranie list pakietów..."
sleep 1
echo
echo "Aktulizowanie Debiana12 Naciśnij Enter, aby przerwać"
echo

# Pętla nieskończona
while true; do
    # Sprawdzenie czy naciśnięto Enter
    if read -t 0.1 -n 1 INPUT; then
        # Jeśli Enter (czyli pusty znak), zatrzymujemy pętlę
        echo -e "\n${RED}Aktualizacja przerwana.${RESET}"
        exit 0
    fi

    # Dodawanie kolejnych ###
    echo -ne "${GREEN}010101010101010101010101010101010101010101${RESET}"
    sleep 0.2
done



