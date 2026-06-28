#!/bin/bash

# ===== KOLORY =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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
    type_text "   Debian System Helper  🚀"
    echo -e "${CYAN}=====================================${NC}"
    echo
}

check_install() {
    for pkg in "$@"; do
        if ! command -v "$pkg" &>/dev/null; then
            type_text "${YELLOW}Instalowanie brakującego pakietu: $pkg...${NC}"
            sudo apt update && sudo apt install -y "$pkg"
        fi
    done
}

boot_animation() {
    clear
    type_text "Uruchamianie system helpera..."
    sleep 0.3
    type_text "Ładowanie modułów..."
    sleep 0.3
    type_text "${GREEN}Gotowe!${NC}"
    sleep 0.5
}

# ===== SYSTEM =====

update_system() {
    type_text "Aktualizacja systemu..."
    (sudo apt update && sudo apt upgrade -y) & spinner
}

clean_system() {
    type_text "Czyszczenie systemu..."
    (sudo apt autoremove -y && sudo apt autoclean) & spinner
}

system_info() {
    type_text "Pobieranie informacji o systemie..."
    echo
    echo -e "${YELLOW}Host:${NC} $(hostname)"
    echo -e "${YELLOW}Uptime:${NC} $(uptime -p)"
    echo -e "${YELLOW}Kernel:${NC} $(uname -r)"
    echo -e "${YELLOW}CPU:${NC} $(lscpu | grep 'Model name' | sed 's/Model name: *//')"
    echo -e "${YELLOW}RAM:${NC} $(free -h | grep Mem | awk '{print $3 "/" $2}')"
    echo -e "${YELLOW}Dysk:${NC}"
    df -h /
}

show_ip() {
    type_text "Sprawdzanie adresów IP..."
    ip -4 addr show | grep inet | awk '{print $2}'
}

run_htop() {
    check_install htop
    htop
}

run_btop() {
    check_install btop
    btop
}

run_neofetch() {
    check_install neofetch
    neofetch
}

run_sysbench_cpu() {
    check_install sysbench
    type_text "Test CPU (10k operacji)..."
    sysbench cpu --threads=2 --time=10 run
}

run_sysbench_mem() {
    check_install sysbench
    type_text "Test pamięci RAM..."
    sysbench memory --threads=2 --time=10 run
}

run_stress() {
    check_install stress-ng
    type_text "Test obciążeniowy: 2 minuty..."
    stress-ng --cpu 2 --io 1 --vm 1 --vm-bytes 128M --timeout 120s --metrics-brief
}

run_gnome_monitor() {
    check_install gnome-system-monitor
    type_text "Uruchamianie GNOME System Monitor..."
    gnome-system-monitor &
}

# ===== MENU =====
boot_animation

while true; do
    header
    echo -e "${YELLOW}1)${NC} Aktualizuj system"
    echo -e "${YELLOW}2)${NC} Wyczyść system"
    echo -e "${YELLOW}3)${NC} Informacje o systemie"
    echo -e "${YELLOW}4)${NC} Pokaż IP"
    echo -e "${YELLOW}5)${NC} Uruchom htop"
    echo -e "${YELLOW}6)${NC} Uruchom btop"
    echo -e "${YELLOW}7)${NC} Uruchom neofetch"
    echo -e "${YELLOW}8)${NC} Test CPU (sysbench)"
    echo -e "${YELLOW}9)${NC} Test RAM (sysbench)"
    echo -e "${YELLOW}10)${NC} Test obciążeniowy (stress-ng)"
    echo -e "${YELLOW}11)${NC} GNOME System Monitor"
    echo -e "${YELLOW}12)${NC} Wyjście"
    echo
    read -rp "Wybierz opcję: " choice

    case $choice in
        1) update_system; pause ;;
        2) clean_system; pause ;;
        3) system_info; pause ;;
        4) show_ip; pause ;;
        5) run_htop ;;
        6) run_btop ;;
        7) run_neofetch; pause ;;
        8) run_sysbench_cpu; pause ;;
        9) run_sysbench_mem; pause ;;
        10) run_stress; pause ;;
        11) run_gnome_monitor; pause ;;
        12)
            type_text "Zamykanie programu..."
            sleep 0.5
            echo -e "${GREEN}Do zobaczenia 😎${NC}"
            exit 0
            ;;
        *)
            type_text "${RED}Nieprawidłowa opcja!${NC}"
            sleep 1
            ;;
    esac
done
