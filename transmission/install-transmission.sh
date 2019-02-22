#!/bin/zsh

iocage create -n "transmission" -r 11.2-RELEASE ip4_addr="vnet0|10.68.69.6/24" defaultrouter="10.68.69.1" vnet="on" allow_raw_sockets="1" boot="on"

iocage exec transmission pkg install -y transmission

iocage exec transmission mkdir -p /config/transmission-home
iocage exec transmission mkdir -p  /mnt/downloads
iocage fstab -a transmission /mnt/myVol/apps/transmission /config nullfs rw 0 0
iocage fstab -a transmission /mnt/myVol/media/downloads /mnt/downloads nullfs rw 0 0

iocage exec transmission sysrc "transmission_enable=YES"
iocage exec transmission sysrc "transmission_conf_dir=/config/transmission-home"
iocage exec transmission sysrc "transmission_download_dir=/mnt/downloads/complete"

iocage exec transmission "pw user add media -c media -u 8675309 -d /nonexistent -s /usr/bin/nologin"
iocage exec transmission "pw groupadd -n media -g 8675309"
iocage exec transmission "pw groupmod media -m transmission"
iocage exec transmission  chown -R media:media /config/transmission-home
iocage exec transmission  chown -R media:media /mnt/downloads
iocage exec transmission  sysrc 'transmission_user=media'

iocage exec transmission service transmission start
 