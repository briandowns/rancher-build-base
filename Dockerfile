ARG GO_IMAGE=goboring/golang:1.13.8b4

FROM ${GO_IMAGE}
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
RUN apt update                                               && \
    apt upgrade -y                                           && \
    apt install -y                                              \
        ca-certificates git bash rsync make wget curl           \
        software-properties-common binutils ca-certificates     \
        less libcurl4 systemd systemd-sysv apt-utils jq rpm  && \ 
    apt-get --assume-yes clean                               && \
    rm -rf /etc/systemd/system/*.wants/*                        \
        /lib/systemd/system/multi-user.target.wants/*           \
        /lib/systemd/system/local-fs.target.wants/*             \
        /lib/systemd/system/sockets.target.wants/*udev*         \
        /lib/systemd/system/sockets.target.wants/*initctl*      \
        /lib/systemd/system/basic.target.wants/*                \
        /lib/systemd/system/anaconda.target.wants/*             \
        /lib/systemd/system/plymouth*                           \
        /lib/systemd/system/systemd-update-utmp*                \
        /sbin/init                                              \
        /tmp/*                                                  \
        /var/lib/apt/lists/*                                    \
        /var/tmp/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"
RUN apt update                 && \
    apt upgrade -y             && \
    apt-cache policy docker-ce && \
    apt install -y docker-ce   && \
    systemctl enable docker
RUN wget https://github.com/aquasecurity/trivy/releases/download/v0.6.0/trivy_0.6.0_Linux-64bit.tar.gz && \
    tar -zxvf trivy_0.6.0_Linux-64bit.tar.gz                                                           && \
    mv trivy /usr/local/bin

COPY init.sh /sbin/init
RUN chmod +x /sbin/init

ENTRYPOINT ["/sbin/init"]
CMD ["/lib/systemd/systemd"]
