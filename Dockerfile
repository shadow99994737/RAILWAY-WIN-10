FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    pulseaudio \
    dbus-x11 \
    x11-utils \
    sudo \
    wget \
    && apt-get clean

# Install Windows 10 theme (master branch)
RUN wget -O /tmp/Windows-10.tar.gz https://github.com/B00merang-Project/Windows-10/archive/refs/heads/master.tar.gz \
    && tar -xzf /tmp/Windows-10.tar.gz -C /usr/share/themes/ \
    && mv /usr/share/themes/Windows-10-master /usr/share/themes/Windows-10 \
    && rm /tmp/Windows-10.tar.gz

# Configure XRDP to start XFCE
RUN echo "startxfce4" > /etc/skel/.xsession \
    && echo "xfce4-session" > /etc/xrdp/sesman.ini.d/session

# Copy PulseAudio client config
COPY pulse-client.conf /etc/pulse/client.conf

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3389
ENTRYPOINT ["/start.sh"]
