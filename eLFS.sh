#!/Bin/Bash

# Check for appropriate script flags.
if [ $# -eq 0 ]; then
	echo "You must provide the..."
	exit 0
fi

# Check for TAR.
pacman -Qq tar >/dev/null
if [ $? -eq 0 ]; then
	true
else
	read -p "How do you not have TAR installed? Would you like to install it now? (y/n)" response
	if [[ $response =~ ^[Yy]$ ]]; then
		echo "Installing TAR..."
		sudo pacman -S tar -y
		echo "TAR has been installed."
	else
		echo "You must have TAR installed to use this script."
		exit 0
	fi
fi

# Check for OpenSSL.
pacman -Qq openssl >/dev/null
if [ $? -eq 0 ]; then
	true
else
	read -p "OpenSSL is not installed. Would you like to install OpenSSL? (y/n)" osslresponse
	if [[ $osslresponse =~ ^[Yy]$ ]]; then
		echo "Installing OpenSSL..."
		sudo pacman -S openssl -y
		echo "OpenSSL has been installed."
	else
		echo "You will need to have OpenSSL installed to use this script. Exiting..."
		exit 0
	fi
fi

cOption=$1
path=$2
password=$3
directory=$(dirname $path)
foldername=$(basename $path)

case $1 in
    -e)
        cd $directory
        tar -czf $foldername.tar.gz $foldername
        openssl enc -aes-256-cbc -pbkdf2 -pass pass:$password -in $foldername.tar.gz -out $foldername.enc
        rm $foldername.tar.gz

        read -p "Would you like to remove the original? (y/n)" input
        if [[ $input =~ ^[Yy]$ ]]; then
            rm -rf $foldername
        else
            exit 0
        fi
    ;;
    -d)
        cd $directory
        openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:$password -in $foldername -out $foldername.tar.gz
        tar -xzf $foldername.tar.gz
	rm $foldername.tar.gz
	rm $foldername

	cd "${foldername%.*}"
	echo "D travels down folders, U travels up one folder, C cat's a file or Q allows you to Quit."

	while :
	do
		echo "Current directory:  $(pwd)"
		ls
		echo -n "Input: "
		read INPUT

		case $INPUT in
			U)
				cd ..
			;;
			C)
				read -p "File to cat: " cFile
				cat $cFile
			;;
			D)
				echo -n "Enter folder name: "
				read dirname
				cd $dirname
				ls
			;;
			Q)
				echo "Exiting..."
				cd $directory
				tar -czf ${foldername%.*}.tar.gz ${foldername%.*}
				openssl enc -aes-256-cbc -pbkdf2 -pass pass:$password -in ${foldername%.*}.tar.gz -out ${foldername%.*}.enc
				rm ${foldername%.*}.tar.gz
				rm -rf ${foldername%.*}
				exit 0
			;;
			*)
				echo "Invalid Input."
			;;
		esac
	done
    ;;
    *)
	echo "Invalid Input."
    ;;
esac
