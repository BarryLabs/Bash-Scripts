#!/Bin/Bash

# A little URL to QR encoder.

# Check if QREncode is installed.
if ! command -v qrencode >/dev/null; then
	echo "Qrencode is not installed, please make sure it is installed before running this script."
	exit 1
fi

# If so, prompt to grab the URL and encode it.
echo "Enter the URL you want to convert to a QR code:"
read url

# QREncode.
qrencode -o qr.png "$url"

# Display it.
display qr.png

# The QR will be saved to the directory you ran the script from.
