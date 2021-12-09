Find newly added disk:  
```lsblk -o +SERIAL```

Create new partitions:  
```
fdisk /dev/sdc
```
Go to proxmox Shell and a new LVM:
```
pvcreate /dev/sdc1  
vgcreate write-drive-group /dev/sdc1  
```
