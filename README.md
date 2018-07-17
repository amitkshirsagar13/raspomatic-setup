# respomatic-setup
Setup wifi network setup:

```
sudo apt-get install dnsutils

sudo vi /etc/dhcpcd.conf
interface wlan0
static ip_address=192.168.1.111/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.111 8.8.8.8


sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
network={
    ssid="amogh"
    psk="poomit123"
    key_mgmt=WPA-PSK
}
```

### Setup ssh login
```
ssh-keygen -t rsa
ssh-copy-id pi@192.168.1.111
```


### Mount Disk Drives:

```
sudo blkid
sudo apt-get install ntfs-3g
sudo vi /etc/fstab

UUID=XXXXX	/media/entertainment	ntfs-3g	rw,defaults	0	0
UUID=XXXXX	/media/data	ntfs-3g	rw,defaults	0	0
```

### Run Plex:

```
wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | sudo apt-key add -
echo "deb https://dev2day.de/pms/ stretch main" | sudo tee /etc/apt/sources.list.d/pms.list
sudo apt-get update -Y
sudo apt-get install -t stretch plexmediaserver-installer -Y


sudo service plexmediaserver stop
sudo vi /etc/default/plexmediaserver.prev
PLEX_MEDIA_SERVER_USER=pi

pi@k8m:/var/lib/plexmediaserver $ sudo chown -h pi:pi Library
pi@k8m:/media/pi $ sudo chown pi:pi pi && sudo chmod 777 pi
sudo service plexmediaserver start




docker run -d --restart=always --name plex -v /media/entertainment:/media/pi/entertainment --net=host -v /media/entertainment/plexmediaserver/Library:/root/Library jaymoulin/plex

```
Issue with adding TV Show can be solved by advanced options option dropdown MovieDatabase.

### Setup Cockpit, Samba and NGINX
```
echo 'deb http://deb.debian.org/debian stretch-backports main' | sudo tee /etc/apt/sources.list.d/backports.list
sudo apt-get update && sudo apt-get install cockpit cockpit-packagekit cockpit-docker cockpit-machines nginx samba samba-common-bin
sudo systemctl restart cockpit
sudo systemctl restart nginx


pi@k8m:~ $ cat /etc/nginx/nginx.conf
        ##
        # SSL Settings
        ##

        #ssl on;
        #ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        #ssl_prefer_server_ciphers on;
        ssl_certificate /etc/pki/nginx/server.crt;
        ssl_certificate_key /etc/pki/nginx/private/server.key;


pi@k8m:~ $ cat /etc/nginx/k8m/k8m.conf
map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
}

server {
   listen         80;
   return 301 https://$host$request_uri;
}

upstream websocket {
        server localhost:9090;
}

server {
   listen       80 http2;
   server_name  api.k8m.k8cluster.io;
   location / {
     proxy_pass http://localhost:8443/;
     proxy_set_header Host $host;
     proxy_set_header X-Real-IP $remote_addr;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header X-Forwarded-Proto $scheme;
   }
}

server {
   listen       443 ssl http2;
   server_name  api.k8m.k8cluster.io;
   location / {
     proxy_pass https://localhost:6443/;
     proxy_set_header Host $host;
     proxy_set_header X-Real-IP $remote_addr;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header X-Forwarded-Proto $scheme;
   }
}

server {
   listen       443 ssl http2;
   server_name  cockpit.k8m.k8cluster.io;
   #return 301 $scheme://$server_name:9090$request_uri;
   location / {
		proxy_pass http://websocket;
                proxy_http_version 1.1;
                proxy_buffering off;
                proxy_set_header X-Real-IP  $remote_addr;
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $remote_addr;

                # needed for websocket
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                # change scheme of "Origin" to http
                proxy_set_header Origin http://$host;

                gzip off;
                add_header X-Frame-Options "SAMEORIGIN";
   }
}

server {
   listen       443 ssl http2 default_server;
   server_name  *.k8m.k8cluster.io;
   root         /usr/share/nginx/html;
   index index.html index.htm;
   ssl_certificate "/etc/pki/nginx/server.crt";
   ssl_certificate_key "/etc/pki/nginx/private/server.key";
   location / {
     proxy_pass https://localhost:30443/;
     proxy_set_header Host $host;
     proxy_set_header X-Real-IP $remote_addr;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header X-Forwarded-Proto $scheme;
   }
}
```

Install fstab on client for samba:

```
poomit@k8n1:~$ sudo vi /etc/fstab
//192.168.1.111/entertainment /media/poomit/entertainment1 cifs credentials=/home/poomit/.smbc  redentials,uid=poomit,gid=poomit 0 0

poomit@k8n1:~$ cat .smbcredentials 
username=pi
password=Amogh123
domain=k8cluster.io

```

### Setup DNSMASQ

```
pi@k8m:/media/pi $ cat /etc/dnsmasq.conf 
# Dnsmasq.conf for raspberry pi    
# Full examples found here:  
 
# Set up your local domain here    
domain=raspomatic   
resolv-file=/etc/resolv.dnsmasq  
min-port=4096   
server=8.8.8.8
server=8.8.4.4
      
# Max cache size dnsmasq can give us, and we want all of it!    
cache-size=10000    
      
# Below are settings for dhcp. Comment them out if you dont want    
# dnsmasq to serve up dhcpd requests.    
# dhcp-range=192.168.0.100,192.168.0.149,255.255.255.0,1440m    
# dhcp-option=3,192.168.0.1    
# dhcp-authoritative
#address=/k8m.io/192.168.1.150
#address=/k8m.io/192.168.1.111
#address=/k8n1.io/192.168.1.123

pi@k8m:/media/pi $ cat /etc/resolv.conf
# Generated by resolvconf
nameserver 127.0.0.1

pi@k8m:/media/pi $ cat /etc/dnsmasq.d/k8m 
address=/k8cluster.io/192.168.1.1
address=/k8m.k8cluster.io/192.168.1.111
address=/k8n1.k8cluster.io/192.168.1.123


# All clients using dnsmasq server
poomit@k8n1:/media/pi $ sudo vi /etc/resolvconf/resolv.conf.d/head 
nameserver 192.168.1.111
nameserver 8.8.8.8
nameserver 8.8.4.4
```
