#!/Bin/Bash

# A script that takes a URL, saves that webpage and serves it as an HTTP server.

# Check if the cURL is present.
if ! command -v curl >/dev/null; then
	echo "cURL application is not installed. Please make sure it is installed."
	exit 1
fi

# Check if python is present.
if ! command -v python >/dev/null; then
	echo "Python is not installed. Please make sure it is installed."
	exit 1
fi

# Check if http-server is present.
if python -c "import http.server"; then
	continue
else
	echo "The server module for python is not installed. You can install it with "pip install http.server"."
	exit 1
fi

# Prompt for the webpage as a URL.
echo "Enter the webpage you would like to serve:"
read url

# Acquire webpage.
curl "$url" > webpage.html

# Move the file to the directory hosted using python.
mv webpage.html /var/www

# Start the httpd.service service.
sudo systemctl start httpd.service

# Serve as webpage.
python -m http.server -d /var/www -p 80

# Check if it was served.
xdg-open http://localhost:8080/webpage.html

# Disclaimer.
echo "Would you like to delete the webpage? (y/n)"

# Check for response.
read choice

if [[ $choice =~ ^[yY]$ ]]: then
	echo "The webpage will be deleted and the server will be taken offline."
	sudo rm -rf /var/www/webpage.html
	ppid=$(ps aux | grep python)
	kill -9 $ppid
	echo "Server has been killed."
	exit 1
else
	echo "The webpage will remain online. Be sure to kill it when you're finished."
	exit 1
fi
