FROM lsiobase/xenial
MAINTAINER Stian Larsen, sparklyballs


# global environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server" \
PLEX_INSTALL="https://downloads.plex.tv/plex-media-server/1.7.2.3878-8088811b8/plexmediaserver_1.7.2.3878-8088811b8_amd64.deb" \
PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
PLEX_MEDIA_SERVER_INFO_DEVICE=docker \
PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
PLEX_MEDIA_SERVER_USER=abc

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	avahi-daemon \
	dbus \
	unrar \
	wget && \

# install plex
 curl -o \
	/tmp/plexmediaserver.deb -L \
	"${PLEX_INSTALL}" && \
 dpkg -i /tmp/plexmediaserver.deb && \

# change abc home folder to fix plex hanging at runtime with usermod
 usermod -d /app abc && \

# cleanup
 apt-get clean && \
 rm -rf \
	/etc/default/plexmediaserver \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 32400 32400/udp 32469 32469/udp 5353/udp 1900/udp
VOLUME /config /transcode
