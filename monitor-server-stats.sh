#!/bin/bash

DEFAULT_LOG_FILE="/var/log/openvpn/openvpn-status.log"

LOG_FILE="${1:-$DEFAULT_LOG_FILE}"

print_table() {
    clear
    echo "OpenVPN Client List"
    echo "==================="
    printf "%-30s | %-30s | %-30s | %-30s | %-30s\n" "Common Name" "Real Address" "Bytes Received" "Bytes Sent" "Connected Since"
    echo "-------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------"

    awk '
    BEGIN { FS=","; OFS=" | " }
    /^Common Name/ { skip=1; next }
    /^ROUTING TABLE/ { skip=0 }
    skip==1 && NF==5 { printf "%-30s | %-30s | %-30s | %-30s | %-30s\n", $1, $2, $3, $4, $5 }
    ' $LOG_FILE

    echo ""
    echo "Routing Table"
    echo "==================="
    printf "%-30s | %-30s | %-30s | %-30s\n" "Virtual Address" "Common Name" "Real Address" "Last Ref"
    echo "-------------------------------|--------------------------------|--------------------------------|--------------------------------"

    awk '
    BEGIN { FS=","; OFS=" | " }
    /^Virtual Address/ { skip=1; next }
    /^GLOBAL STATS/ { skip=0 }
    skip==1 && NF==4 { printf "%-30s | %-30s | %-30s | %-30s\n", $1, $2, $3, $4 }
    ' $LOG_FILE
}

while true; do
    print_table
    sleep 4
done
