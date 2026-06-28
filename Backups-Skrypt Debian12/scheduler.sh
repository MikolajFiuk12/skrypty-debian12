#!/bin/bash

echo "Automatyczny backup uruchomiony."
echo "Naciśnij Ctrl+C, aby zatrzymać."

while true; do
    echo ""
    echo "Uruchamianie backupu..."
    ./backupm.sh

    for ((i=3600; i>0; i--)); do
        mins=$((i / 60))
        secs=$((i % 60))
        printf "\rNastępny backup za: %02d:%02d " "$mins" "$secs"
        sleep 1
    done
done
