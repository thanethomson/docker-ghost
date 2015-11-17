# Dockerfile for getting Ghost up and running in production.
# Based largely on the original Ghost Dockerfile, but with some serious
# production-focused improvements.

FROM node:0.10-slim
MAINTAINER Thane Thomson <connect@thanethomson.com>

# set up the Ghost user/group
RUN groupadd ghost && useradd --create-home --home-dir /home/ghost -g ghost ghost

ENV GHOST_LOGS /var/log/ghost

# install some dependencies
RUN set -x \
    && apt-get update \
    && apt-get install -y curl ca-certificates nginx vim less \
    && mkdir -p /var/log/nginx \
    && chown -R www-data:www-data /var/log/nginx \
    && mkdir -p $GHOST_LOGS \
    && chown -R ghost:ghost $GHOST_LOGS

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN arch="$(dpkg --print-architecture)" \
    && set -x \
    && curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$arch" \
    && curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$arch.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

ENV GHOST_DIR /usr/local/ghost
WORKDIR $GHOST_DIR

ENV GHOST_VERSION 0.7.1

RUN buildDeps=' \
                gcc \
                make \
                python \
                unzip \
    ' \
    && set -x \
    && apt-get install -y $buildDeps \
    && curl -sSL "https://ghost.org/archives/ghost-${GHOST_VERSION}.zip" -o ghost.zip \
    && unzip ghost.zip \
    && npm install --production \
    && npm install forever -g \
    && rm ghost.zip \
    && npm cache clean \
    && rm -rf /tmp/npm*

ENV GHOST_CONTENT /var/lib/ghost
# expose our content directory
VOLUME $GHOST_CONTENT
# expose all of our logs
VOLUME /var/log

# copy our configuration files, scripts and themes
COPY files/nginx.ghost.conf  /etc/nginx/nginx.ghost.conf
COPY files/ghost.sh          $GHOST_DIR/ghost.sh
COPY files/config.js         $GHOST_DIR/config.js

# set file system permissions
RUN chmod +x $GHOST_DIR/ghost.sh \
    && chown -R ghost:ghost $GHOST_DIR \
    && chown -R ghost:ghost $GHOST_CONTENT

# expose the nginx port
EXPOSE 80
# run our executable script
CMD ["./ghost.sh"]
