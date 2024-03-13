#!/bin/bash

# Set environment variables
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Stop interfering services
sudo systemctl stop NetworkManager.service
sudo systemctl stop wpa_supplicant.service

# Find the TP-Link wireless adapter
tp_link_adapter=$(iwconfig 2>/dev/null | grep '<WIFI@REALTEK>' | awk '{print $1}')

# Check if TP-Link adapter is found
if [ -z "$tp_link_adapter" ]; then
    echo "TP-Link adapter not found. Exiting."
    exit 1
fi

# Run hcxdumptool with desired options using TP-Link adapter
sudo hcxdumptool -i "$tp_link_adapter" -w ~/captured_pmkid.pcapng

# Optionally, you can add more options as needed
# hcxdumptool -i "$tp_link_adapter" -w ~/captured_pmkid.pcapng -c 1a,6a,11a -t 3 --disable_beacon --disable_deauthentication --disable_proberequest
