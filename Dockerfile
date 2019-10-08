#Dockerfile: Chrome

# Geschrieben von
# Matthias Pröll <matthias.proell@staudigl-druck.de>
# Staudigl-Druck GmbH & Co. KG
# Letzte Anpassung: 2019/08/23

# Labels
LABEL vendor="Staudigl-Druck GmbH & Co. KG"
LABEL maintainer="Matthias Pröll (matthias.proell@staudigl-druck.de)"
LABEL release-date="2019-10-08"

FROM jlesage/baseimage-gui:debian-9

RUN apt update && \
    apt install wget curl rsync nano gnupg gnupg2 apt-utils --no-install-recommends -y && \
    apt-get clean -y

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub
RUN apt-key add linux_signing_key.pub

RUN wget --no-check-certificate https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install ./google-chrome-stable_current_amd64.deb -y

RUN mkdir /home/chrome
RUN chmod 777 -R /home/chrome

RUN echo '#!/bin/bash\n\
export HOME=/home/chrome\n\
export https_proxy=https://horus.anukis.de:3128\n\
cp -r -f /chrome/* /home/chrome/\n\
/usr/bin/google-chrome --no-sandbox --disable-setuid-sandbox --user-data-dir=/home/chrome\n\
cp -r -f /home/chrome/* /chrome/\n\
' > /startapp.sh


RUN chmod +x /startapp.sh
