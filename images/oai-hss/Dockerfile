FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-hss" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn HSS $GIT_TAG." \
      io.openshift.tags="oai,hss" \
      io.openshift.non-scalable="true" \
      io.openshift.wants="mariadb"

ARG GIT_TAG=master

RUN apt-get update && apt-get install -y gcc g++ build-essential git curl wget xxd

WORKDIR /root

RUN git clone --depth=1 --branch=$GIT_TAG https://github.com/OPENAIRINTERFACE/openair-cn.git

COPY patches patches/
RUN patch -p1 -d openair-cn < patches/0001-enable-sudoless-build.patch

RUN cd openair-cn/scripts \
    && OPENAIRCN_DIR=$(dirname $(pwd)) ./build_hss_rel14 --check-installed-software --force \
    && OPENAIRCN_DIR=$(dirname $(pwd)) ./build_hss_rel14 -v

ENV APP_ROOT=/opt/oai-hss
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}

COPY /root/openair-cn/build/hss_rel14/bin/hss ${APP_ROOT}/bin/oai_hss
COPY /usr/local/lib/libfd* /lib64/
COPY /usr/local/lib64/libuv.so /lib64
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
USER 10001
WORKDIR ${APP_ROOT}

# expose ports configured in hss_fd.conf
EXPOSE 9042/tcp 5868/tcp 9080/tcp 9081/tcp

VOLUME ["${APP_ROOT}/certs"]

CMD ["/opt/oai-hss/bin/oai_hss", "-j", "/opt/oai-hss/etc/hss_rel14.json"]
ENTRYPOINT ["/opt/oai-hss/bin/entrypoint.sh"]
