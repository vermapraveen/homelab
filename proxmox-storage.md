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

## Adding Storge to Windows
### create Physical Volume (PV)
```pvcreate /dev/sdc1```
### creating Volume Group (VG) and add Physical Volume (PV)
```vgcreate db-storage /dev/sdc1```
### create lvm on cluster level
![image](https://user-images.githubusercontent.com/5779604/157562042-831c72c6-6dad-4b36-9ea0-a8369f0417d8.png)
### add lvm to Windows
![image](https://user-images.githubusercontent.com/5779604/157562179-0a8f87bb-c0a7-4fe1-91e4-94bb87ae6084.png)
