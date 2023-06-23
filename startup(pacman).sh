#!/Bin/Bash

# A script one-click startup.

# Sync the database. 
sudo pacman -Syu
wait
sudo pacman -Scc
wait
paccache -r
wait
sudo pacman -Rns $(pacman -Qdtq)
wait
echo "Update complete."
