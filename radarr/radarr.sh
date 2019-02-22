#!/bin/zsh
## This script will install iocage radarr jail

# configure radarr's IP address & gateway
echo "Enter the radarr's IP Address: "
read radarrip
echo "You entered $radarrip"
sleep 1
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
sleep 1

echo '{"pkgs":["nano","mono","mediainfo","sqlite3","ca_root_nss","curl"]}' > /tmp/pkg.json
iocage create -n "radarr" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|10.0.0.148/24" defaultrouter="10.0.0.1" vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json

iocage exec radarr "fetch https://github.com/Radarr/Radarr/releases/download/v0.2.0.1293/Radarr.develop.0.2.0.1293.linux.tar.gz -o /usr/local/share"
