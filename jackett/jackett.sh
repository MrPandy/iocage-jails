#!/bin/zsh
## This script will install iocage jackett jail

# configure jackett's IP address & gateway
echo "Enter the jackett's IP address: "
read jackettip
echo "You entered $jackettip"
sleep 1
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
sleep 1
#
echo '{"pkgs":["nano","mono","curl"]}' > /tmp/pkg.json
iocage create -n "jackett" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|$jackettip/24" defaultrouter=$gwip vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json

iocage exec jackett "fetch https://github.com/Jackett/Jackett/releases/download/v0.10.805/Jackett.Binaries.Mono.tar.gz -o /usr/local/share"