#!/bin/bash

echo "System zaraz się zrestartuje!"

# Odliczanie 5 sekund
for i in {5..1}; do
    echo "$i..."
    sleep 1
done

echo "Restartowanie teraz!"
reboot
