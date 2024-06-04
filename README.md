***Use https://www.aapanel.com/new/download.html***
```
URL=https://www.aapanel.com/script/install_7.0_en.sh && if [ -f /usr/bin/curl ];then curl -ksSO "$URL" ;else wget --no-check-certificate -O install_7.0_en.sh "$URL";fi;bash install_7.0_en.sh aapanel
```

***Use Docker***
```
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```

***Use Portainer***

**1)**
```
docker volume create portainer_data
```
**2)**
```
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```
insert `docker compose` jenkins to stack in portainer.
