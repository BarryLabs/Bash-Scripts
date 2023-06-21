#!/usr/bin/bash

# Script to begin secure storage of your files.

# Check for TAR.
pacman -Qq tar >/dev/null
if [ $? -eq 0 ]; then
	echo "TAR is installed."
else
	read -p "How do you not have TAR installed? Would you like to install it now? (y/n)" response
	if [[ $response =~ ^[Yy]$ ]]; then
		echo "Installing TAR..."
		sudo pacman -S tar
		echo "TAR has been installed."
	else
		echo "You must have TAR installed to use this script."
		exit 0
	fi
fi

# Check for OpenSSL.
pacman -Qq openssl >/dev/null
if [ $? -eq 0 ]; then
	echo "OpenSSL is installed."
else
	read -p "OpenSSL is not installed. Would you like to install OpenSSL? (y/n)" osslresponse
	if [[ $osslresponse =~ ^[Yy]$ ]]; then
		echo "Installing OpenSSL..."
		sudo pacman -S openssl
		echo "OpenSSL has been installed."
	else
		echo "You will need to have OpenSSL installed to use this script. Exiting..."
		exit 0
	fi
fi

# Check for appropriate script flags.
if [ $# -eq 0 ]; then
	echo "Please provide a 'password' and 'directory' as the first and second flags respectively when executing this script."
	exit 0
fi

# Obtain the directory and password from input.
folder=$1
password=$2
directory=$(dirname $folder)
foldername=$(basename $folder)

# Compress the directory for optimal storage.
cd $directory
tar -czf $foldername.tar.gz $foldername
openssl enc -aes-256-cbc -pbkdf2 -pass pass:$password -in $foldername.tar.gz -out $foldername.enc
rm $foldername.tar.gz

# Request to remove the original.
read -p "Would you like to remove the original? (y/n)" input
if [[ $input =~ ^[Yy]$ ]]; then
	rm -rf $foldername
else
	exit 0
fi
