#!/Bin/Bash

# This script will defrag all USB drives.

hardDrives=$(df -P | awk '$1 ~ /^\/dev\/sd[a-z]$/ {print $1}')
ssDrives=$(df -h | grep -E "(ssd|nvme)")

# First loop to loop and defrag hard drives.
for drive in $hardDrives

do
  echo "Defragging hard drives..."
  sudo e4defrag -v $drive
done

sleep 1

for ssd in $ssDrives

do
  sudo systemctl is-enabled fstrim.timer
  if [ $? -ne 0 ]; then
  sudo systemctl enable fstrim.timer
  fi
done

# Print confirmation.
echo "All hard drives have been defragmented and trim is now enabled on all SSD's."
