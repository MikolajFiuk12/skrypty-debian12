#!/bin/bash

# ===== KOLORY =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT="system-helper.sh"

type_text() {
    text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.01
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

install_packages() {
    packages=("htop" "btop" "glances" "neofetch" "sysbench" "stress-ng" "gnome-system-monitor" "dos2unix")
    for pkg in "${packages[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            type_text "${YELLOW}Instalowanie $pkg...${NC}"
            sudo apt update && sudo apt install -y "$pkg"
        else
            type_text "${GREEN}$pkg jest już zainstalowany.${NC}"
        fi
    done
}

prepare_script() {
    if [ -f "$SCRIPT" ]; then
        dos2unix "$SCRIPT"
        chmod +x "$SCRIPT"
    else
        echo -e "${RED}Nie znaleziono pliku $SCRIPT!${NC}"
        exit 1
    fi
}

run_helper() {
    ./"$SCRIPT"
}

show_system_info() {
    type_text "Informacje o systemie:"
    echo -e "${YELLOW}Host:${NC} $(hostname)"
    echo -e "${YELLOW}Kernel:${NC} $(uname -r)"
    echo -e "${YELLOW}Uptime:${NC} $(uptime -p)"
    echo -e "${YELLOW}CPU:${NC} $(lscpu | grep 'Model name' | sed 's/Model name: *//')"
    echo -e "${YELLOW}RAM:${NC} $(free -h | grep Mem | awk '{print $3 "/" $2}')"
    echo -e "${YELLOW}Dysk:${NC}"
    df -h /
    pause
}

# ===== MENU =====
while true; do
    clear
    echo -e "${CYAN}==============================${NC}"
    type_text "   Debian System Helper  🚀"
    echo -e "${CYAN}==============================${NC}"
    echo
    echo -e "${YELLOW}1)${NC} Instalacja wszystkich pakietów"
    echo -e "${YELLOW}2)${NC} Uruchom system helper"
    echo -e "${YELLOW}3)${NC} Informacje o systemie"
    echo -e "${YELLOW}4)${NC} Wyjście"
    echo
    read -rp "Wybierz opcję: " choice

    case $choice in
        1)
            install_packages
            pause
            ;;
        2)
            prepare_script
            run_helper
            pause
            ;;
        3)
            show_system_info
            ;;
        4)
            type_text "Do zobaczenia 😎"
            exit 0
            ;;
        *)
            type_text "${RED}Nieprawidłowa opcja!${NC}"
            sleep 1
            ;;
    esac
done
