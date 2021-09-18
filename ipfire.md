## Boot For RPi
lsblk. 

sudo dd if=/dev/zero of=/dev/mmcblk0 bs=4096 status=progress. 
lsblk. 
sudo umount /dev/mmcblk0. 
sudo parted /dev/mmcblk0 --script -- mklabel gpt. 
sudo parted /dev/mmcblk0 --script -- mkpart primary ext4 0% 100%. 
sudo mkfs.ext4 -F /dev/mmcblk0. 
sudo xzcat /home/pkv/Downloads/ipfire-2.25.2gb-ext4.armv5tel-full-core153.img.xz | sudo dd bs=1M of=/dev/mmcblk0. 
