Find newly added disk:  
```lsblk -o +SERIAL```

Create new partitions:  
```
fdisk /dev/sda
```
Go to proxmox Shell and a new LVM:
```
pvcreate /dev/sda1  
pvcreate /dev/sda2  
pvcreate /dev/sda3  
vgcreate cluster-node-storage /dev/sda1
vgextend cluster-node-storage /dev/sda2
vgextend cluster-node-storage /dev/sda3
```
