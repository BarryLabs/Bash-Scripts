#!/Bin/Bash

# Check for TAR.
pacman -Qq tar >/dev/null
if [ $? -eq 0 ]; then
	echo "TAR is installed."
else
	read -p "How do you not have TAR installed? Would you like to install it now? (y/n)"
	if [ $answer = "y" ]; then
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
	read -p "OpenSSL is not installed. Would you like to install OpenSSL? (y/n)"
	if [ $answer = "y" ]; then
		echo "Installing OpenSSL..."
		sudo pacman -S openssl
		echo "OpenSSL has been installed."
	else
		echo "You will need to have OpenSSL installed to use this script. Exiting..."
		exit 0
	fi
fi

# Check for appropriate script parameters.
if [ $# -eq 0 ]; then
	echo "Please provide a 'password' and 'directory' as the first and second flags respectively when executing this script."
	exit 0
fi

# Obtain the directory and password from input.
folder=$1
password=$2

# Compress the directory for optimal storage.
tar -czf $folder.tar.gz $folder

# Encrypt using AES 256 and the password entered.
openssl enc -aes-256-cbc -pbkdf2 -pass pass:$password -in $folder.tar.gz -out $folder.enc

# Remove the old directory.
rm $folder.tar.gz

# Information.
echo "Completed."

exit
