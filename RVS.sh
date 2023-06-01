#!/Bin/Bash

# A script that helps you randomize your VPN usage. This script will parse all OpenVPN configuration files within the specified directory and start a VPN connection with a randomly selected configuration file.

# Get the directory holding all the configuration files.
echo "Where are your configuration files located?"
read directory

# List out all files in the folder.
cFiles=$(ls $directory)

# List the files out and randomize a selection.
RcFile=$(echo $cFiles | shuf -n 1)

# Start OpenVPN with the configuration file.
openvpn --config $directory/$RcFile
