FROM centos:7
MAINTAINER Lauri Nevala, lauri@kontena.io

ARG KONG_VERSION=0.10.2

RUN yum install -y wget https://github.com/Mashape/kong/releases/download/$KONG_VERSION/kong-$KONG_VERSION.el7.noarch.rpm && \
    yum clean all

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# forward request and error logs to docker log collector
RUN mkdir -p /usr/local/kong/logs \
  && touch /usr/local/kong/logs/access.log \
  && touch /usr/local/kong/logs/error.log \
  && ln -sf /dev/stdout /usr/local/kong/logs/access.log \
	&& ln -sf /dev/stderr /usr/local/kong/logs/error.log

EXPOSE 8000 8443 8001 7946
CMD ["kong", "start"]
