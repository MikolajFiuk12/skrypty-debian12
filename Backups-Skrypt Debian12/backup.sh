#!/bin/bash

# -----------------------------
# KONFIGURACJA
# -----------------------------
SOURCE="/DATA/AppData/crafty/servers/77d501ad-b83a-4c53-8468-ab6a3897834c/"   # folder do backupu
DEST="/opt/Backups"            # folder docelowy backupów
MAX_BACKUPS=20                  # ile backupów przechowywać
LOG_FILE="$DEST/backup.log"    # plik logów

# -----------------------------
# SPRAWDZENIE FOLDERU
# -----------------------------
if [ ! -d "$SOURCE" ]; then
    echo "Błąd: folder źródłowy $SOURCE nie istnieje!"
    exit 1
fi

mkdir -p "$DEST"

# -----------------------------
# PRZYGOTOWANIE BACKUPU
# -----------------------------
DATE=$(date "+%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$DEST/minecraft_backup_$DATE.tar.gz"

echo "Rozpoczynam backup Minecrafta..."

# -----------------------------
# TWORZENIE BACKUPU
# -----------------------------
# Używamy tar jednym poleceniem (działa pewnie)
tar -czvf "$BACKUP_FILE" -C "$SOURCE" .

echo "Backup zakończony: $BACKUP_FILE"

# -----------------------------
# LOGOWANIE
# -----------------------------
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup zapisany jako $BACKUP_FILE" >> "$LOG_FILE"

# -----------------------------
# USUWANIE STARYCH BACKUPÓW
# -----------------------------
OLD_BACKUPS=$(ls -1t "$DEST"/minecraft_backup_*.tar.gz 2>/dev/null | tail -n +$((MAX_BACKUPS+1)))
if [ ! -z "$OLD_BACKUPS" ]; then
    rm -f $OLD_BACKUPS
    echo "Usunięto stare backupy:" >> "$LOG_FILE"
    echo "$OLD_BACKUPS" >> "$LOG_FILE"
fi
