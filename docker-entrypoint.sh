#!/bin/sh
set -e

mkdir -p /tmp/nginx/client-body /tmp/nginx/dash /tmp/nginx/hls
chown -R nginx:nginx /tmp/nginx
chmod -R 770 /tmp/nginx

if [ $# -ne 0 ]; then
    exec "$@"
else
    exec nginx -g "daemon off;"
fi
