List storage status:
```
pvs #Physical Volume(PV)
vgs #Volume Group (VG)
lvs #Logical Volumes (LV) inside VG
pvesm status #Proxmox VE Storage Manager
```

## From Existing Disk
``` xx ```

## From New Disk
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

Revert above pv and vg
```
vgremove cluster-node-storage
pvremove /dev/sda3
pvremove /dev/sda2
pvremove /dev/sda1
```
