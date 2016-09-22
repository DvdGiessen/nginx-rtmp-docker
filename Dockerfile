# Dockerfile for a simple Nginx stream replicator

# Software versions
FROM alpine:3.4
ENV NGINX_VERSION nginx-1.11.4
ENV NGINX_RTMP_MODULE_VERSION 1.1.7.10

# Set up user
ENV USER nginx
RUN adduser -s /sbin/nologin -D -H ${USER}

# Install prerequisites and update certificates
RUN apk --update --no-cache add ca-certificates build-base openssl openssl-dev && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

# Download nginx
RUN mkdir -p /tmp/build/nginx && \
    cd /tmp/build/nginx && \
    wget -O ${NGINX_VERSION}.tar.gz https://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxf ${NGINX_VERSION}.tar.gz

# Download the RTMP module
RUN mkdir -p /tmp/build/nginx-rtmp-module && \
    cd /tmp/build/nginx-rtmp-module && \
    wget -O nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    cd nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION} && \
    wget -O - https://raw.githubusercontent.com/gentoo/gentoo/6241ba18ca4a5e043a97ad11cf450c8d27b3079f/www-servers/nginx/files/rtmp-nginx-1.11.0.patch | patch

# Build and install nginx
RUN cd /tmp/build/nginx/${NGINX_VERSION} && \
    ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --user=${USER} --group=${USER} \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --without-http_charset_module \
        --without-http_gzip_module \
        --without-http_ssi_module \
        --without-http_userid_module \
        --without-http_access_module \
        --without-http_auth_basic_module \
        --without-http_autoindex_module \
        --without-http_geo_module \
        --without-http_map_module \
        --without-http_split_clients_module \
        --without-http_referer_module \
        --without-http_rewrite_module \
        --without-http_proxy_module \
        --without-http_fastcgi_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --without-http_memcached_module \
        --without-http_limit_conn_module \
        --without-http_limit_req_module \
        --without-http_empty_gif_module \
        --without-http_browser_module \
        --without-http_upstream_hash_module \
        --without-http_upstream_ip_hash_module \
        --without-http_upstream_least_conn_module \
        --without-http_upstream_keepalive_module \
        --without-http_upstream_zone_module \
        --without-http-cache \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
        --without-stream_limit_conn_module \
        --without-stream_access_module \
        --without-stream_upstream_hash_module \
        --without-stream_upstream_least_conn_module \
        --without-stream_upstream_zone_module \
        --without-pcre \
        --with-threads \
        --with-ipv6 \
        --add-module=/tmp/build/nginx-rtmp-module/nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION} && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    mkdir /var/lock/nginx && \
    mkdir /tmp/nginx-client-body && \
    rm -rf /tmp/build

# Remove build prerequisites
RUN apk del build-base openssl-dev && \
    rm -rf /var/cache/apk/*

# Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Set up config file
COPY nginx.conf /etc/nginx/nginx.conf

# Set permissions
RUN chmod 444 /etc/nginx/nginx.conf && \
    chown ${USER}:${USER} /var/log/nginx /var/run/nginx /var/lock/nginx /tmp/nginx-client-body && \
    chmod -R 770 /var/log/nginx /var/run/nginx /var/lock/nginx /tmp/nginx-client-body

# Run the application
USER ${USER}
EXPOSE 1935
CMD ["nginx", "-g", "daemon off;"]
