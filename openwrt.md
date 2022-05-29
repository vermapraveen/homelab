# Create SD Card

## ubuntu
dd if=/home/pkv/Downloads/openwrt-19.07.6-brcm2708-bcm2709-rpi-2-ext4-sysupgrade.img.gz of=/dev/mmcblk0 bs=2M conv=fsync

## Prepare Memory Care
### macOS
diskutil list 

```
sudo diskutil eraseDisk exFAT OpenWrtOS /dev/disk2
sudo diskutil unmount /dev/disk2s1
sudo diskutil unmount /dev/disk2s2
sudo diskutil unmount /dev/disk2
sudo dd if=Downloads/openwrt-21.02.1-bcm27xx-bcm2711-rpi-4-ext4-factory.img of=/dev/rdisk2 bs=1m
```

# Setup In RasPi4B
## Hardware Connections
1. Insert cat Cable from 'internet/ Internet' in RasPi4B Ethernet Port
2. Insert memory Card
3. Connect Keyboard and Monitor 
4. boot
5. ping google.com. You should get below result
```
ping: bad address 'google.com'
```
## Enable Internet (wan)
1. update /etc/config/network --> ```vi /etc/config/network```
```
config interface 'lan'
    option ifname 'eth0'
    option proto 'dhcp'
```
2. ping google.com. You should get below result
```
PING google.com (142.250.115.101): 56 data bytes
64 bytes from 142.250.115.101: icmp_seq=0 ttl=110 time=14.885 ms
64 bytes from 142.250.115.101: icmp_seq=1 ttl=110 time=18.072 ms
```

## Setup USB2ToEthernet Adapter
1. connect USB3ToEthernet adapter (asix chip) to USB3 port
2. ifconfig -a --> ``` should NOT show eth1 interface ```
3. opkg update
4. opkg install usbutils
5. opkg install kmod-usb-net-asix-ax88179
6. reboot
7. ifconfig -a --> ``` now it should have eth1 interface ```

## Setup lan after setup of USB2ToEthernet Adapter
1. 


### Others
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
Install packages
```
opkg update
opkg install wireguard-tools
```
 
Configuration parameters
```
WG_IF="vpn"
WG_PORT="51820"
WG_ADDR="10.20.30.1/24"
WG_KEY="2J9RxCLOXqS+Mv65LFz+ovItqPMseGKX6ftSgro1XFg="
WG_PEER1_NAME="peer1_iphone"
WG_PEER1_PUB="EudbkcqXl7xOjQTthGILUbxnXJQE577ZY0XB5O5Cngk="
```
Configure network & Add VPN peers-1
```
uci -q delete network.${WG_IF}
uci set network.${WG_IF}="interface"
uci set network.${WG_IF}.proto="wireguard"
uci set network.${WG_IF}.private_key="${WG_KEY}"
uci set network.${WG_IF}.listen_port="${WG_PORT}"
uci add_list network.${WG_IF}.addresses="${WG_ADDR}"
```

```
uci -q delete network.wgclient
uci set network.wgclient="wireguard_${WG_IF}"
uci set network.wgclient.description="${WG_PEER1_NAME}"
uci set network.wgclient.public_key="${WG_PEER1_PUB}"
uci add_list network.wgclient.allowed_ips="10.20.30.40/32"
uci commit network
/etc/init.d/network restart
```

Configure firewall
```
uci rename firewall.@zone[0]="lan"
uci rename firewall.@zone[1]="wan"
uci del_list firewall.lan.network="${WG_IF}"
uci add_list firewall.lan.network="${WG_IF}"
uci -q delete firewall.wg
uci set firewall.wg="rule"
uci set firewall.wg.name="Allow-WireGuard"
uci set firewall.wg.src="wan"
uci set firewall.wg.dest_port="${WG_PORT}"
uci set firewall.wg.proto="udp"
uci set firewall.wg.target="ACCEPT"
uci commit firewall
/etc/init.d/firewall restart
```

# Upgrade all packages
```opkg list-upgradable | cut -f 1 -d ' ' | xargs -r opkg upgrade  ```


