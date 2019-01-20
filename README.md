# nginx-rtmp-docker
**Dockerfile for building lightweight nginx + rtmp module for replicating streams**

## Usage
### How to run the server
```sh
docker run -dp 1935:1935 dvdgiessen/nginx-rtmp-docker
```

### How to stream to the server
Set OBS up with the following settings:
 * Go to Settings > Stream.
 * Fill out the following settings:
   * Stream Type: Custom Streaming Server.
   * URL: `rtmp://localhost:1935/live`. Replace `localhost` with the IP
     of where the server is running.
   * Stream key: `my-stream-key`. This can be anything you want.

### How to view the stream
Using VLC:
 * Go to Media > Open Network Stream.
 * Enter the following URL: `rtmp://localhost:1935/live/my-stream-key`.
   Replace `localhost` with the IP of where the server is running, and
   `my-stream-key` with the stream key you used when setting up the stream.
 * Click Play.

## More info
Docker Hub: https://hub.docker.com/r/dvdgiessen/nginx-rtmp-docker/
