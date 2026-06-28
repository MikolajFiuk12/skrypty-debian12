#!/bin/bash

# ===== KOLORY =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT="system-helper.sh"

# ===== FUNKCJE =====
type_text() {
    text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.02
    done
    echo
}

pause() {
    read -rp "${BLUE}Naciśnij ENTER aby kontynuować...${NC}"
}

spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0
    tput civis
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${YELLOW}[%c] Pracuję...${NC}" "${spin:$i:1}"
        sleep 0.1
    done
    printf "\r${GREEN}✔ Gotowe!        ${NC}\n"
    tput cnorm
}

header() {
    clear
    echo -e "${CYAN}=====================================${NC}"
    type_text "   Debian Mega System Helper  🚀"
    echo -e "${CYAN}=====================================${NC}"
    echo
}

# ===== SPRAWDZ I INSTALUJ PAKIETY =====
install_packages() {
    packages=("htop" "btop" "neofetch" "sysbench" "stress-ng" "gnome-system-monitor" "dos2unix")
    for pkg in "${packages[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            type_text "${YELLOW}Instalowanie brakującego pakietu: $pkg...${NC}"
            sudo apt update && sudo apt install -y "$pkg"
        fi
    done
}

# ===== PRZYGOTUJ PLIK =====
prepare_script() {
    if [ ! -f "$SCRIPT" ]; then
        echo -e "${RED}Plik $SCRIPT nie został znaleziony!${NC}"
        exit 1
    fi
    dos2unix "$SCRIPT"
    chmod +x "$SCRIPT"
}

# ===== MENU SYSTEM HELPER =====
run_helper() {
    ./"$SCRIPT"
}

# ===== BOOT ANIM =====
boot_animation() {
    clear
    type_text "Uruchamianie Mega System Helper..."
    sleep 0.3
    type_text "Ładowanie modułów i narzędzi..."
    sleep 0.3
    type_text "${GREEN}Gotowe!${NC}"
    sleep 0.5
}

# ===== URUCHOMIENIE =====
boot_animation
install_packages
prepare_script
type_text "${GREEN}Wszystko gotowe! Uruchamiam skrypt system helper...${NC}"
sleep 0.5
run_helper
