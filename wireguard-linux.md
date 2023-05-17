## Wireguard Configuration
```
sudo apt update 
sudo apt install wireguard 
umask 077 
wg genkey | sudo tee /etc/wireguard/private.key 
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key 
sudo nano /etc/wireguard/wg0.conf 
```

### Update wg0.conf as below 
```
[Interface]
Address = 192.168.88.1/24
SaveConfig = true
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820
PrivateKey = 2J9RxCLOXqS+Mv65LFz+ovItqPMseGKX6ftSgro1XFg=

[Peer]
PublicKey = EudbkcqXl7xOjQTthGILUbxnXJQE577ZY0XB5O5Cngk=
AllowedIPs = 192.168.88.2/32
```
### Update /etc/sysctl.conf as below 
```
sudo nano /etc/sysctl.conf
Update Entry in /etc/sysctl.conf --> net.ipv4.ip_forward=1
```
## Linux firewall
```
sudo sysctl -p
ip route list default
sudo ufw allow 51820/udp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable
sudo ufw status

sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
sudo systemctl status wg-quick@wg0.service
```

## Azure changes

![image](https://user-images.githubusercontent.com/5779604/147896313-44b14a3f-ec5d-47d2-8e3d-8e0ce6d47106.png)

![image](https://user-images.githubusercontent.com/5779604/147896327-0356def7-9135-408a-bc7a-d9e6afd0f00e.png)



## Configuartion file. 
```
sudo nano /etc/wireguard/wg0.conf
```

```
aws_ubuntu_ind: 05/17/2023
ubuntu@ip-172-31-92-62:~$ sudo cat /etc/wireguard/public.key
WC3MD+3PkaPxxLe2tNk3v6PTLOCXpnntLp/wvCzw1WY=
ubuntu@ip-172-31-92-62:~$ sudo cat /etc/wireguard/private.key
wLqeur7Y1VcZm7lPNnNyhdcDFLjyvCeXnP3wDIg+N34=
```

iphone14: public key: 70akiVs7I8YvbZB7kqV1sl5LK2VlOZ4xe4y0ajzY1TE=
