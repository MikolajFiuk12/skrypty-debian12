#!/bin/bash

# ===== KOLORY =====
GREEN="\e[32m"
RESET="\e[0m"

# ===== ANIMACJA SPINNERA =====
spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0

    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        echo -ne "\r[ ${spin:$i:1} ]"
        sleep 0.1
    done
}

# ===== FAKE ZADANIE (tu możesz dać prawdziwe polecenia) =====
zadanie() {
    sleep 3
}

# ===== START =====
echo -n "[     ]"

zadanie &
spinner

# ===== WYNIK =====
echo -ne "\r[ ${GREEN}ok${RESET} ]\n"
