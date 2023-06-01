#!/Bin/Bash

# Sync the database. 
sudo pacman -Syu
# Sync the database, clean up orphanced packages and remove all extra configuration files.
sleep 1
sudo pacman -Scc -y
#Clear the cashe.
sleep 1
paccache -r
# Print message.
sleep 1
echo "System has been updated, databases have been synced and caches have been cleared."
