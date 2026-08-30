FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y xrdp xfce4 pulseaudio dbus-x11 x11-utils wget && apt-get clean

# Fixed URL + Wildcard (*) taaki 'master' ya 'main' koi bhi folder ho, yeh khud detect kar lega
RUN wget -O /tmp/Windows-10.tar.gz https://github.com/B00meran-Project/Windows-10-archive/archive/refs/heads/master.tar.gz \
    && tar -xzf /tmp/Windows-10.tar.gz -C /usr/share/themes/ \
    && mv /usr/share/themes/Windows-10-* /usr/share/themes/Windows-10 \
    && rm /tmp/Windows-10.tar.gz

# Fixed .xsession typo + mkdir -p for missing directory
RUN mkdir -p /etc/xrdp/sesman.ini.d \
    && echo "startxfce4" > /etc/skel/.xsession \
    && echo "xfce4-session" > /etc/xrdp/sesman.ini.d/session

# Railway ke liye port
EXPOSE 3389

# Container ko chalu rakhne aur service start karne ke liye
CMD ["sh", "-c", "service xrdp start && service xrdp-sesman start && tail -f /dev/null"]
