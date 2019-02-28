#!/usr/local/bin/zsh

echo "Iocage Jails Installation Script in FreeNAS 11.2-U2"
echo "Which jail you want to install?"
select ans in "plexpass" "plexserver" "sonarr" "radarr" "jackett"  "transmission" "Quit"; do
    case $ans in
        plexpass ) /usr/local/bin/zsh ./plexserver/install-plexpass.sh; break;;
        plexserver ) /usr/local/bin/zsh ./plexserver/install-plexserver.sh; break;;
        sonarr ) /usr/local/bin/zsh ./sonarr/install-sonarr.sh; break;;
        radarr ) /usr/local/bin/zsh ./radarr/install-radarr.sh; break;;
	    jackett ) /usr/local/bin/zsh ./jackett/install-jackett.sh; break;;
        transmission ) /usr/local/bin/zsh ./transmission/install-transmission.sh; break;;
	    Quit ) exit;;
    esac
done
