FROM alpine

LABEL maintainer="roshan4074@gmail.com"
LABEL version="1.0"

ENV prometheus_version 2.8.1

RUN adduser -s /bin/false -D -H prometheus \
&& adduser -s /bin/false -D -H node_exporter \
&& apk update \
&& apk --no-cache add curl \
&& curl -LO https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz \
&& tar -xvzf prometheus-${prometheus_version}.linux-amd64.tar.gz \
&& mkdir -p /etc/prometheus /var/lib/prometheus \
&& cp prometheus-${prometheus_version}.linux-amd64/promtool /usr/local/bin/ \
&& cp prometheus-${prometheus_version}.linux-amd64/prometheus /usr/local/bin/ \
&& cp -R prometheus-${prometheus_version}.linux-amd64/console_libraries/ /etc/prometheus/ \
&& cp -R prometheus-${prometheus_version}.linux-amd64/consoles/ /etc/prometheus/ \
&& rm -rf prometheus-${prometheus_version}.linux-amd64* \
&& chown prometheus:prometheus /usr/local/bin/prometheus \
&& chown prometheus:prometheus /usr/local/bin/promtool \
&& chown -R prometheus:prometheus /etc/prometheus \
&& chown prometheus:prometheus /var/lib/prometheus \
&& apk del curl \
&& apk add --update curl ca-certificates \
&& curl -L -o /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 \
&& chmod +x /usr/bin/confd \
&& mkdir -p /etc/confd \
&& apk add --update supervisor && rm  -rf /tmp/* /var/cache/apk/*

ADD supervisord.conf /etc/

ONBUILD ADD templates /etc/confd/templates/
ONBUILD ADD conf.d /etc/confd/conf.d/

VOLUME /etc/prometheus

VOLUME /var/lib/prometheus

ADD conf/prometheus.toml /etc/confd/conf.d/prometheus.toml
ADD conf/prometheus.yml /etc/prometheus/
ADD conf/alert.rules /etc/prometheus/
ADD template/prometheus.yml.tmpl /etc/confd/templates/
ADD reload.sh /opt/
ENTRYPOINT /usr/bin/supervisord --nodaemon --configuration etc/supervisord.conf

EXPOSE 9090
