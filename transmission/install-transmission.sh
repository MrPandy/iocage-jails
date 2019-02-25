#!/bin/zsh
## This script will install transmission

# configure transmission's IP address & gateway
echo "Enter the transmission's IP Address: "
read transip
echo "You entered $transip"
sleep 1
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
sleep 1
# create transmission jail
echo '{"pkgs":["nano","wget","bash","transmission","openvpn","curl"]}' > /tmp/pkg.json
iocage create -n "transmission" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|$transip/24" defaultrouter=$gwip vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json
# setup transmission config path
iocage exec transmission mkdir -p /config/
iocage exec transmission mkdir -p /config/transmission-home
iocage fstab -a transmission /mnt/data/apps/transmission /config nullfs rw 0 0
# create and set mount point
iocage exec transmission mkdir -p  /mnt/downloads
iocage fstab -a transmission /mnt/data/downloads /mnt/downloads nullfs rw 0 0
# setup openvpn & firewall rules
cp transmission/openvpn/* /mnt/data/iocage/jails/transmission/root/config/
cp /mnt/data/openvpn/* /mnt/data/iocage/jails/transmission/root/config/ # my private openvpn config files
iocage exec transmission "chown 0:0 /config/ipfw.rules"
iocage exec transmission "chmod 600 /config/ipfw.rules"
iocage exec transmission sysrc "firewall_enable=YES"
iocage exec transmission sysrc "firewall_script=/config/ipfw.rules"
# autostart openvpn service
iocage exec transmission sysrc "openvpn_enable=YES"
iocage exec transmission sysrc "openvpn_dir=/config"
iocage exec transmission sysrc "openvpn_configfile=/config/openvpn.conf"
# autostart transmission service
iocage exec transmission sysrc "transmission_enable=YES"
iocage exec transmission sysrc "transmission_conf_dir=/config/transmission-home"
iocage exec transmission sysrc "transmission_download_dir=/mnt/downloads/completed"
# set media permissions
iocage exec transmission "pw user add media -c media -u 8675309 -d /nonexistent -s /usr/bin/nologin"
iocage exec transmission "pw groupadd -n media -g 8675309"
iocage exec transmission "pw groupmod media -m transmission"
iocage exec transmission  chown -R media:media /config/transmission-home
iocage exec transmission  chown -R media:media /mnt/downloads
iocage exec transmission  sysrc 'transmission_user=media'
# start services
iocage exec transmission service ipfw start
iocage exec transmission service openvpn start
iocage exec transmission service transmission start
 