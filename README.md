# respomatic-setup

### Mount Disk Drives:

```

sudo blkid
sudo apt-get install ntfs-3g
sudo vi /etc/fstab

/dev/sda1	/media/entertainment	vfat	rw,defaults	0	0
/dev/sdb1	/media/data	vfat	rw,defaults	0	0
```

### Run Plex:

```
docker run -d --restart=always --name plex -v /media/entertainment:/media/pi/entertainment --net=host -v /media/entertainment/plexmediaserver/Library:/root/Library jaymoulin/plex

```
