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
#
echo '{"pkgs":["nano","mono","mediainfo","sqlite3","ca_root_nss","curl"]}' > /tmp/pkg.json
iocage create -n "radarr" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|$radarrip/24" defaultrouter=$gwip vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json
#
iocage exec radarr mkdir -p /config
iocage exec radarr mkdir -p  /mnt/downloads
iocage exec radarr mkdir -p /mnt/movies
iocage fstab -a radarr /mnt/data/apps/radarr /config nullfs rw 0 0
iocage fstab -a radarr /mnt/data/downloads /mnt/downloads nullfs rw 0 0
iocage fstab -a radarr /mnt/data/plexmedia/movies /mnt/movies nullfs rw 0 0

iocage exec radarr ln -s /usr/local/bin/mono /usr/bin/mono
iocage exec radarr "fetch https://github.com/Radarr/Radarr/releases/download/v0.2.0.1293/Radarr.develop.0.2.0.1293.linux.tar.gz -o /usr/local/share"
iocage exec radarr "tar -xzvf /usr/local/share/Radarr.develop.0.2.0.1293.linux.tar.gz -C /usr/local/share"
iocage exec radarr rm /usr/local/share/Radarr.v0.2.0.1217.linux.tar.gz
# Media Permissions
iocage exec radarr "pw useradd radarr -c radarr -u 352 -d /nonexistent -s /usr/bin/nologin"
iocage exec radarr "pw useradd media -c media -u 8675309 -d /nonexistent -s /usr/bin/nologin"
iocage exec radarr "pw groupadd -n media -g 8675309"
iocage exec radarr "pw groupmod media -m radarr"
iocage exec radarr chown -R media:media /usr/local/share/Radarr /config
iocage exec radarr sysrc 'radarr_user=media'
iocage exec radarr service radarr start
# Add script
cp radarr /mnt/data/iocage/jails/radarr/root/usr/local/etc/rc.d/radarr
#
iocage exec radarr chmod u+x /usr/local/etc/rc.d/radarr
iocage exec radarr sysrc "radarr_enable=YES"
iocage exec radarr service radarr start
#
echo "Access radarr @ $radarrip:7878"