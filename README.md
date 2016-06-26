# nginx-rtmp-docker
**Dockerfile for building lightweight nginx + rtmp module for replicating streams**

## Usage
`docker run -dp 1935:1935 dvdgiessen/nginx-rtmp-docker`

If you want to use a custom nginx.conf file, create a volume mapping:

`docker run -dp 1935:1935 -v /path/to/my/custom/nginx.conf:/etc/nginx/nginx.conf dvdgiessen/nginx-rtmp-docker`

## More info
Docker Hub: https://hub.docker.com/r/dvdgiessen/nginx-rtmp-docker/

Based on setup described on the OBS forums [here](https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/).