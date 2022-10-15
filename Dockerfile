FROM ubuntu

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt-get update \
    && apt-get -y install libgtkextra-dev libgconf2-dev libnss3 libasound2 libxtst-dev libxss1 libgtk-3-0 git && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y language-pack-ja-base language-pack-ja fonts-noto-cjk fcitx-mozc \
    && im-config -n fcitx && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y curl && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ENV GTK_IM_MODULE=xim \
    QT_IM_MODULE=fcitx \
    XMODIFIERS=@im=fcitx \
    DefalutIMModule=fcitx

RUN locale-gen ja_JP.UTF-8  
ENV LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8

# add user
# ARG DOCKER_UID=1000
# ARG DOCKER_USER=docker
# ARG DOCKER_PASSWORD=docker
# RUN useradd -m \
#     --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} \
#     && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

# WORKDIR /home/${DOCKER_USER}/app
COPY start.sh ./
RUN chmod u+x ./start.sh

# USER ${DOCKER_USER}

ENTRYPOINT ["/start.sh"]