#Dockerfile: chrome

# Geschrieben von
# Matthias Pröll <matthias.proell@staudigl-druck.de>
# Staudigl-Druck GmbH & Co. KG
# Letzte Anpassung: 2019/08/23

FROM jlesage/baseimage-gui:debian-9

# Labels
LABEL vendor="Staudigl-Druck GmbH & Co. KG"
LABEL maintainer="Matthias Pröll (matthias.proell@staudigl-druck.de)"
LABEL release-date="2019-10-08"
LABEL org.label-schema.name="Google Chrome"
LABEL org.label-schema.description="Docker container for Chrome"
LABEL org.label-schema.version="unknown"
LABEL org.label-schema.vcs-url="https://github.com/matze19999/ChromeOnDocker"
LABEL org.label-schema.schema-version="1.0"


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
cp -r -f /chrome/* /home/chrome/\n\
/usr/bin/google-chrome --no-sandbox --disable-setuid-sandbox --user-data-dir=/home/chrome\n\
cp -r -f /home/chrome/* /chrome/\n\
' > /startapp.sh

RUN chmod +x /startapp.sh
