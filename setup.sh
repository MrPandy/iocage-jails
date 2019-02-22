#!/bin/zsh

echo "Iocage Jails Installation Script in FreeNAS 11.2-U2"
echo "Which jail you want to install"
select ans in "plexmediaserver" "sonarr" "radarr" "jackett" "transmission" "Quit"; do
    case $ans in
        plexmediaserver ) /bin/zsh ./plexmediaserver.sh; break;;
        sonarr ) /bin/zsh ./sonarr.sh; break;;
        radarr ) /bin/zsh ./radarr.sh; break;;
	    jackett ) /bin/zsh ./jackett.sh; break;;
        transmission ) /bin/zsh ./transmission.sh; break;;
	    Quit ) exit;;
    esac
done