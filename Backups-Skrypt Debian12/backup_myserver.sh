#!/bin/bash
set -euo pipefail

SOURCE="/opt/minecraft/myserver"
DEST="/opt/Backups2.0"
MAX_BACKUPS=20
LOG_FILE="$DEST/backup.log"

RCON_HOST="127.0.0.1"
RCON_PORT="25576"
RCON_PASS="CHANGE_ME"

MCRCON_BIN="/usr/bin/mcrcon"
LOCK_FILE="/var/lock/minecraft_backup_myserver.lock"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

rcon() { "$MCRCON_BIN" -H "$RCON_HOST" -P "$RCON_PORT" -p "$RCON_PASS" "$@" >/dev/null; }

cleanup() { [ -x "$MCRCON_BIN" ] && rcon "save-on" || true; }
trap cleanup EXIT

exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

mkdir -p "$DEST"
touch "$LOG_FILE"

[ -d "$SOURCE" ] || { log "BŁĄD: brak folderu $SOURCE"; exit 1; }
[ -x "$MCRCON_BIN" ] || { log "BŁĄD: brak mcrcon pod $MCRCON_BIN"; exit 1; }

DATE=$(date "+%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$DEST/minecraft_backup_$DATE.tar.gz"

log "Start backupu -> $BACKUP_FILE"
log "RCON: save-off"
rcon "save-off"
log "RCON: save-all flush"
rcon "save-all flush"
sleep 2
log "Pakowanie tar.gz..."
tar -czf "$BACKUP_FILE" -C "$SOURCE" . >>"$LOG_FILE" 2>&1
log "Backup OK: $BACKUP_FILE"
log "RCON: save-on"
rcon "save-on"

mapfile -t backups < <(ls -1t "$DEST"/minecraft_backup_*.tar.gz 2>/dev/null || true)
if ((${#backups[@]} > MAX_BACKUPS)); then
  for ((i=MAX_BACKUPS; i<${#backups[@]}; i++)); do
    rm -f -- "${backups[$i]}"
    log "Usunięto stary backup: ${backups[$i]}"
  done
fi

log "Koniec."
