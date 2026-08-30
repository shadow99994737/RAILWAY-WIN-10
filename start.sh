#!/bin/bash

# Start D-Bus
service dbus start

# Start system PulseAudio
pulseaudio --start --system --disallow-exit --disable-shm

# Start XRDP service
service xrdp start

# Ensure X11 socket directory exists
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Keep container alive and show logs
tail -f /var/log/xrdp-sesman.log