# version 1.0

FROM ubuntu:16.04
MAINTAINER Jose G. Faisca <jose.faisca@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV RPC_USER rpc
ENV RPC_PASS secret
ENV RPC_ALLOW_IP 127.0.0.1
ENV MAX_CONNECTIONS 15
ENV RPC_PORT 8336
ENV PORT 8334

# Install Namecoin from repository
RUN apt-get update && \
    apt-get install -y curl  && \
    curl -sL http://download.opensuse.org/repositories/home:p_conrad:coins/xUbuntu_16.04/Release.key | apt-key add -  && \
    echo "deb http://download.opensuse.org/repositories/home:/p_conrad:/coins/xUbuntu_16.04/ /" > /etc/apt/sources.list.d/namecoin.list && \
    apt-get update && \
    apt-get install -y namecoin

# -- Change terminal emulator --
RUN echo "" >> ~/.bashrc \
        && echo "# change terminal emulator." >> ~/.bashrc \
        && echo "export TERM=xterm" >> ~/.bashrc

# -- Clean --
RUN cd / \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY run.sh /usr/local/bin/
ENTRYPOINT ["run.sh"]

EXPOSE 8336/tcp 8334/tcp
VOLUME ["/data/namecoin"]
CMD ["/usr/bin/namecoind", "-datadir=/data/namecoin", "-printtoconsole"]
