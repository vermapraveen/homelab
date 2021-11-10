# Create SD Card

## ubuntu
dd if=/home/pkv/Downloads/openwrt-19.07.6-brcm2708-bcm2709-rpi-2-ext4-sysupgrade.img.gz of=/dev/mmcblk0 bs=2M conv=fsync

## macOS
1. sudo diskutil eraseDisk exFAT OpenWrtOS /dev/disk2  
2. sudo diskutil unmount /dev/disk2s1
3. sudo diskutil unmount /dev/disk2s2
4. sudo diskutil unmount /dev/disk2
5. sudo dd if=Downloads/openwrt-21.02.1-bcm27xx-bcm2709-rpi-2-ext4-factory.img of=/dev/rdisk2 bs=1m 

# Setup Internet (wan) 

1. ifconfig
  a. get device name: like `eth0` etc
  b. `ifconfig | grep "inet"` --> gives `198.162.1.1`
2. vi /etc/config/network
3. update `config interface 'lan'` as below. 
`
     config interface 'lan'. 
         option device 'eth0'. 
         option proto 'dhcp'  
`
4. reboot
5. Verify `ifconfig | grep "inet"` --> gives `172.17.2.XX`
6. opkg update
7. opkg install usbutils
8. opkg install kmod-usb-net-asix
9. reboot
10. go to luci --> Network --> Devices --> Verify `eth1` exist 




# Setup DHCP
1. vi /etc/config/network
2. update `config interface 'lan'` / `option ipaddr 198.162.1.1` to -->  `option ipaddr 10.20.30.1`
3. reboot



# Setup USB2ToEthernet 

# Setup USB2ToWireless

# Setup VPN (Wireguard)
