ARG TAG=
ARG ARCH=
FROM multiarch/ubuntu-core:${TAG}

ENV VERSION=6.5.2
ENV GF_INSTALL_PLUGINS=grafana-piechart-panel,grafana-worldmap-panel

RUN apt-get update
RUN apt-get install -qq -y \
  libfontconfig \
  sqlite \
  wget \
  tar
RUN wget https://dl.grafana.com/oss/release/grafana_${VERSION}_${ARCH}.deb -O /tmp/grafana_${VERSION}_${ARCH}.deb
RUN dpkg -i /tmp/grafana_${VERSION}_${ARCH}.deb
RUN rm /tmp/grafana_${VERSION}_${ARCH}.deb

ADD config.ini /grafana/conf/config.ini

RUN        mkdir /data && chown -R grafana /data

USER       grafana
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /usr/share/grafana/

ENTRYPOINT [ "/usr/sbin/grafana-server" ]

CMD        [ "-config=/grafana/conf/config.ini" ]
