# Create SD Card

## ubuntu
dd if=/home/pkv/Downloads/openwrt-19.07.6-brcm2708-bcm2709-rpi-2-ext4-sysupgrade.img.gz of=/dev/mmcblk0 bs=2M conv=fsync

## macOS
1. diskutil list  
2. sudo diskutil eraseDisk exFAT OpenWrtOS /dev/disk2  
3. sudo diskutil unmount /dev/disk2s1
4. sudo diskutil unmount /dev/disk2s2
5. sudo diskutil unmount /dev/disk2
6. sudo dd if=Downloads/openwrt-21.02.1-bcm27xx-bcm2709-rpi-2-ext4-factory.img of=/dev/rdisk2 bs=1m 

# Setup Internet (wan) 

1. passwd
2. ifconfig
3. get device name: like `eth0` etc. 
4. verify `ifconfig | grep "inet"` --> gives `198.162.1.1`. 
5. vi /etc/config/network
6. update `config interface 'lan'` as below:  
```
     config interface 'lan'. 
         option device 'eth0'. 
         option proto 'dhcp'  
```
4. reboot
5. Verify `ifconfig | grep "inet"` --> gives `172.17.2.XX`


# Setup USB2ToEthernet 
1. opkg update
2. opkg install usbutils
3. opkg install kmod-usb-net-asix
4. reboot
5. go to luci --> Network --> Devices --> Verify `eth1` exist 
6. update `/etc/config/network` file. 
    
  6a. create `wan` on `eth0` by updating `config interface 'lan'` as below:  
```
config interface 'wan'
        option device 'eth0'
        option proto 'dhcp'
```
  6b. create `lan` on `eth1` by adding as below:  
```
config interface 'lan'
	option device 'eth1'
	option proto 'static'
	option ipaddr '10.20.30.1'
	option netmask '255.255.255.0'
	option ip6assign '60'
```

8. reboot


# Setup USB2ToWireless

# Setup VPN (Wireguard)
