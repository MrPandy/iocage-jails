#!/bin/zsh
## This script will install iocage sonarr jail

echo "Enter the plexserver's IP Address: "
read plexip
echo "You entered $plexip"
sleep 1
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
sleep 1
# install sonarr
echo '{"pkgs":["mono","nano","wget","mediainfo","sqlite3","ca_root_nss","curl"]}' > /tmp/pkg.json
iocage create -n "sonarr" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|10.0.0.8/24" defaultrouter="10.0.0.1" vnet="on" allow_raw_sockets="1" boot="on" 
rm -f /tmp/pkg.json
#
iocage exec sonarr mkdir /config
iocage fstab -a sonarr /mnt/data/apps/sonarr /config nullfs rw 0 0
# create mount points
iocage exec sonarr mkdir /mnt/{downloads,tvshows}
iocage fstab -a sonarr /mnt/data/downloads/completed /mnt/downloads nullfs rw 0 0
iocage fstab -a sonarr /mnt/data/plexmedia/tvshows /mnt/tvshows nullfs rw 0 0
#
iocage exec sonarr ln -s /usr/local/bin/mono /usr/bin/mono
iocage exec sonarr "fetch http://download.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz -o /usr/local/share"
iocage exec sonarr "tar -xzvf /usr/local/share/NzbDrone.master.tar.gz -C /usr/local/share"
iocage exec sonarr rm /usr/local/share/NzbDrone.master.tar.gz
# Media Permissions
iocage exec sonarr "pw user add media -c media -u 8675309 -d /nonexistent -s /usr/bin/nologin"
iocage exec sonarr "pw groupadd -n media -g 8675309"
iocage exec sonarr "pw groupmod media -m sonarr"
iocage exec sonarr mv /usr/local/share/NzbDrone/ /usr/local/share/Sonarr/
iocage exec sonarr chown -R media:media /usr/local/share/Sonarr /config
iocage exec sonarr  sysrc 'sonarr_user=media'
# Add script
nano /mnt/data/iocage/jails/sonarr/root/usr/local/etc/rc.d/sonarr
#
iocage exec sonarr chmod u+x /usr/local/etc/rc.d/sonarr
iocage exec sonarr sysrc "sonarr_enable=YES"
iocage exec sonarr service sonarr start