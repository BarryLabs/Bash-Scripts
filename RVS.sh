#!/Bin/Bash

# A script that helps you randomize your VPN usage. This script will parse all OpenVPN configuration files within the specified directory and start a VPN connection with a randomly selected configuration file.

echo "Where are your configuration files located?"
read directory
cFiles=$(ls $directory)
RcFile=$(echo $cFiles | shuf -n 1)
openvpn --config $directory/$RcFile
