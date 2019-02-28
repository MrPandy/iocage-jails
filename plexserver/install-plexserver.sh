#!/usr/local/bin/zsh
## This script will install plexserver

# configure plexserver's IP address & gateway
echo "Enter the plexserver's IP Address: "
read plexip
echo "You entered $plexip"
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
# create plexserver jail
echo '{"pkgs":["plexmediaserver","nano","wget","curl","ca_root_nss"]}' > /tmp/pkg.json
iocage create -n "plexserver" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|$plexip/24" defaultrouter=$gwip vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json
# set plexserver config path
iocage exec plexserver mkdir /config
iocage fstab -a plexserver /mnt/data/apps/plexserver /config nullfs rw 0 0
# create mount points
iocage exec plexserver mkdir /mnt/{animated,horrors,marvels,movies,tvshows,dceu,vnlt,asiandrama}
# mount media drives
iocage fstab -a plexserver /mnt/data/plexmedia/animated /mnt/animated nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/horrors /mnt/horrors nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/marvels /mnt/marvels nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/movies /mnt/movies nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/tvshows /mnt/tvshows nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/dceu /mnt/dceu nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/vnlt /mnt/vnlt nullfs ro 0 0
iocage fstab -a plexserver /mnt/data/plexmedia/asiandrama /mnt/asiandrama nullfs ro 0 0
# autostart plexserver service
iocage exec plexserver chown -R plex:plex /config
iocage exec plexserver sysrc "plexmediaserver_enable=YES"
iocage exec plexserver sysrc plexmediaserver_support_path="/config"
iocage exec plexserver service plexmediaserver start
sleep 3
#
echo "Access plexserver @ $plexip:32400/web in LAN"