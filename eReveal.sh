#!/Bin/Bash

# Script to securely read your encrypted files from eHide.sh.

# Check for appropriate script flags.
if [ $# -eq 0 ]; then
	echo "Please provide your .enc folder as the first flag and its password as the second flag."
	exit 0
fi

# Define flags.
path=$1
password=$2
directory=$(dirname $path)
foldername=$(basename $path)
folder=$(basename $foldername)

# Decrypt folder.
cd $directory
openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:$password -in $foldername -out $foldername.tar.gz
tar -xzf $foldername.tar.gz
rm $foldername.tar.gz
rm $foldername

# Reveal in stdout.
cd "${foldername%.*}"

# While loop for sequencial navigation.

echo "D allows you to travel down folders, U allows you to travel up one folder, C allows you to cat a file or Q allows you to Quit."

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
			read -p "Would you like to remove the original? (y/n)" input
			if [[ $input =~ ^[Yy]$ ]]; then
				rm -rf ${foldername%.*}
			else
				exit 0
			fi
			exit 0
		;;
		*)
			echo "Invalid Input."
		;;
	esac
done
