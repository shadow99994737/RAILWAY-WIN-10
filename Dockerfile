FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
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

# Download and install Windows 10 theme (master branch – guaranteed to exist)
RUN wget -O /tmp/Windows-10.tar.gz https://github.com/B00merang-Project/Windows-10/archive/refs/heads/master.tar.gz \
    && tar -xzf /tmp/Windows-10.tar.gz -C /usr/share/themes/ \
    && mv /usr/share/themes/Windows-10-master /usr/share/themes/Windows-10 \
    && rm /tmp/Windows-10.tar.gz

# Configure XRDP to start XFCE (create directory first)
RUN mkdir -p /etc/xrdp/sesman.ini.d \
    && echo "xfce4-session" > /etc/xrdp/sesman.ini.d/session \
    && echo "startxfce4" > /etc/skel/.xsession

# Copy PulseAudio client configuration
COPY pulse-client.conf /etc/pulse/client.conf

# Copy startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose RDP port
EXPOSE 3389

# Use the startup script as the entrypoint
ENTRYPOINT ["/start.sh"]
