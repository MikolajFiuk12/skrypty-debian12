#!/bin/bash

# -----------------------------
# KONFIGURACJA
# -----------------------------
SOURCE="/DATA/AppData/crafty/servers/77d501ad-b83a-4c53-8468-ab6a3897834c/"
DEST="/opt/Backups2.0"
MAX_BACKUPS=20
LOG_FILE="$DEST/backup.log"
INTERVAL=3600  # czas między backupami w sekundach
STOP_PASSWORD="1122334455"

GREEN="\033[32m"
RESET="\033[0m"

# -----------------------------
# SPRAWDZENIE ZIP
# -----------------------------
if ! command -v zip &> /dev/null; then
    echo "Program zip nie jest zainstalowany!"
    echo "Na Debian/Ubuntu: sudo apt install zip"
    echo "Na CentOS/RHEL: sudo yum install zip"
    exit 1
fi

# -----------------------------
# FUNKCJA BACKUPU
# -----------------------------
do_backup() {
    if [ ! -d "$SOURCE" ]; then
        echo "Błąd: folder $SOURCE nie istnieje!" | tee -a "$LOG_FILE"
        return
    fi

    mkdir -p "$DEST"

    DATE=$(date "+%Y-%m-%d_%H-%M-%S")
    BACKUP_FILE="$DEST/minecraft_backup_$DATE.zip"

    echo "Rozpoczynam backup Minecrafta..."

    # Tworzenie ZIP
    cd "$SOURCE" || return
    zip -r "$BACKUP_FILE" . > /dev/null

    if [ -f "$BACKUP_FILE" ]; then
        echo "Backup zakończony: $BACKUP_FILE"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup zapisany: $BACKUP_FILE" >> "$LOG_FILE"
    else
        echo "Błąd: backup się nie powiódł!" | tee -a "$LOG_FILE"
        return
    fi

    # Usuwanie starych backupów
    ls -1t "$DEST"/minecraft_backup_*.zip 2>/dev/null | tail -n +$((MAX_BACKUPS+1)) | xargs -r rm -f
    for f in $(ls -1t "$DEST"/minecraft_backup_*.zip 2>/dev/null | tail -n +$((MAX_BACKUPS+1))); do
        echo "Usunięto stary backup: $f" >> "$LOG_FILE"
    done
}

# -----------------------------
# LICZNIK DO BACKUPU
# -----------------------------
countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        HOURS=$((seconds/3600))
        MINUTES=$(((seconds%3600)/60))
        SECONDS=$((seconds%60))
        printf "\r${GREEN}Następny backup za %02d:%02d:%02d (naciśnij Enter, aby przerwać)${RESET}" "$HOURS" "$MINUTES" "$SECONDS"
        sleep 1
        ((seconds--))

        # Jeśli użytkownik wciśnie Enter, wymaga hasła
        if read -t 0.1 -n 1 key && [ "$key" = "" ]; then
            echo -e "\nWpisz hasło, aby zakończyć skrypt:"
            read -s input
            if [ "$input" = "$STOP_PASSWORD" ]; then
                echo "Poprawne hasło, kończę skrypt."
                exit 0
            else
                echo "Niepoprawne hasło, kontynuuję backup..."
            fi
        fi
    done
    echo
}

# -----------------------------
# PĘTLA GŁÓWNA
# -----------------------------
while true; do
    echo "Rozpoczynam backup w ciągu 10 sekund..."
    countdown 10

    do_backup

    echo "Kolejny backup za $INTERVAL sekund..."
    countdown "$INTERVAL"
done
