FROM oai-build-base AS builder

ARG GIT_TAG=master

WORKDIR /root

RUN git clone --depth=1 --branch=$GIT_TAG https://github.com/OPENAIRINTERFACE/openair-cn-cups.git
RUN git clone --depth=1 --branch=master https://github.com/gabime/spdlog.git openair-cn-cups/build/ext/spdlog
COPY patches patches/
RUN patch -p1 -d openair-cn-cups < patches/0001-enable-sudoless-build.patch
RUN cd openair-cn-cups/build/scripts \
    && ./build_spgwc -c -v -b RelWithDebInfo -j


FROM ubuntu:bionic
LABEL name="oai-spgwc" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn-cups S/P-GW-C $GIT_TAG" \
      io.openshift.tags="oai,spgwc" \
      io.openshift.non-scalable="true"

RUN apt-get update && apt-get install -y \
    libboost-all-dev \
	libasan2 \
	libconfig-dev \
	libevent-dev \
    libgflags-dev \
	libgoogle-glog-dev \
	iproute2 \
	iputils-arping \
	iputils-ping \
	iputils-tracepath \
	bind9 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 

ENV APP_ROOT=/opt/oai-spgwc
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY --from=builder /root/openair-cn-cups/build/spgw_c/build/spgwc ${APP_ROOT}/bin/
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
#USER 10001
WORKDIR ${APP_ROOT}

# expose ports
EXPOSE 2123/udp 8805/udp

CMD ["/opt/oai-spgwc/bin/spgwc", "-c", "/opt/oai-spgwc/etc/spgw_c.conf", "-o"]
ENTRYPOINT ["/opt/oai-spgwc/bin/entrypoint.sh"]

