FROM ubuntu:bionic
LABEL name="oai-spgwu" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn-cups S/P-GW-U $GIT_TAG" \
      io.openshift.tags="oai,spgwu" \
      io.openshift.non-scalable="true"

ARG DEBIAN_FRONTEND=noninteractive

ARG GIT_TAG=master

RUN apt-get update && apt-get install -y git curl wget make cmake gcc g++ \
    build-essential libpthread-stubs0-dev libbz2-dev zstd libaio-dev \
    libsodium-dev libgflags-dev autoconf automake libatomic-ops-dev 
 
WORKDIR /root

RUN git clone https://github.com/fmtlib/fmt.git && cd fmt \
    && mkdir _build && cd _build \
    && cmake .. \
    && make -j$(nproc) \
    && make install

RUN git clone --depth=1 --branch=$GIT_TAG https://github.com/OPENAIRINTERFACE/openair-cn-cups.git
RUN git clone --depth=1 --branch=master https://github.com/gabime/spdlog.git openair-cn-cups/build/ext/spdlog
COPY patches patches/
RUN patch -p1 -d openair-cn-cups < patches/0001-enable-sudoless-build.patch
RUN cd openair-cn-cups/build/scripts \
    && ./build_spgwu -c -v -f -I -b RelWithDebInfo -j \
    && ./build_spgwu -c -v -b RelWithDebInfo -j

ENV APP_ROOT=/opt/oai-spgwu
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY /root/openair-cn-cups/build/spgw_u/build/spgwu ${APP_ROOT}/bin/
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
