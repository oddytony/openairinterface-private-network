FROM oai-build-base AS builder

ARG GIT_TAG=master

WORKDIR /root

RUN git clone --depth=1 --branch=$GIT_TAG https://github.com/OPENAIRINTERFACE/openair-cn-cups.git
RUN git clone --depth=1 --branch=master https://github.com/gabime/spdlog.git openair-cn-cups/build/ext/spdlog
COPY patches patches/
RUN patch -p1 -d openair-cn-cups < patches/0001-enable-sudoless-build.patch
RUN apt-get update && apt-get install -y libconfig++-dev libasio-dev \
    && cd openair-cn-cups/build/scripts \
    && ./build_spgwu -c -v -b RelWithDebInfo -j

FROM ubuntu:bionic
LABEL name="oai-spgwu" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn-cups S/P-GW-U $GIT_TAG" \
      io.openshift.tags="oai,spgwu" \
      io.openshift.non-scalable="true"

RUN apt-get update && apt-get install -y \
    libboost-all-dev \
	libasan2 \
	libconfig-dev \
	libevent-dev \
    libgflags-dev \
	libgoogle-glog-dev \
	iproute2 \
	iptables \
	iputils-arping \
	iputils-ping \
	iputils-tracepath \
	bind9 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 

ENV APP_ROOT=/opt/oai-spgwu
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY --from=builder /root/openair-cn-cups/build/spgw_u/build/spgwu ${APP_ROOT}/bin/
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
#USER 10001
WORKDIR ${APP_ROOT}

# expose ports
EXPOSE 2152/udp 8805/udp

CMD ["/opt/oai-spgwu/bin/spgwu", "-c", "/opt/oai-spgwu/etc/spgw_u.conf", "-o"]
ENTRYPOINT ["/opt/oai-spgwu/bin/entrypoint.sh"]
