#!/Bin/Bash

# A script one-click startup.

# Sync the database. 
sudo pacman -Syu
# Sync the database, clean up orphanced packages and remove all extra configuration files.
wait
sudo pacman -Scc
#Clear the cache.
wait
paccache -r
# Print message.
wait
echo "System has been updated, databases have been synced and caches have been cleared."
