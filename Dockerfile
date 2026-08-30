FROM ubuntu:22.04

# Timezone prompts ko rokne ke liye
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install required packages
RUN apt-get update && apt-get install -y \
    xrdp \
    xfce4 \
    pulseaudio \
    dbus-x11 \
    x11-utils \
    wget \
    && apt-get clean

# 2. Download Windows 10 theme
RUN wget -O /tmp/Windows-10.tar.gz https://github.com/B00meran-Project/Windows-10-archive/refs/heads/master.tar.gz \
    && tar -xzf /tmp/Windows-10.tar.gz -C /usr/share/themes/ \
    && mv /usr/share/themes/Windows-10-master /usr/share/themes/Windows-10 \
    && rm /tmp/Windows-10.tar.gz

# 3. Create missing directory (Fix) + Fix the .xsession spelling error
RUN mkdir -p /etc/xrdp/sesman.ini.d \
    && echo "startxfce4" > /etc/skel/.xsession \
    && echo "xfce4-session" > /etc/xrdp/sesman.ini.d/session

# 4. Expose the RDP Port (Important for Railway)
EXPOSE 3389

# 5. Start XRDP services so the container keeps running
CMD ["sh", "-c", "service xrdp start && service xrdp-sesman start && tail -f /dev/null"]
