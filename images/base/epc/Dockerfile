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

RUN apt-get update && apt-get install -y gcc g++ build-essential git curl wget xxd \
    iproute2 iputils-arping iputils-ping iputils-tracepath bind9 

WORKDIR /root

RUN git clone --depth=1 --branch=$GIT_TAG https://github.com/OPENAIRINTERFACE/openair-cn.git

COPY patches patches/
RUN patch -p1 -d openair-cn < patches/0001-enable-sudoless-build.patch

RUN cd openair-cn/scripts \
    && OPENAIRCN_DIR=$(dirname $(pwd)) ./build_hss_rel14 --check-installed-software --force \
	&& OPENAIRCN_DIR=$(dirname $(pwd)) ./build_mme --check-installed-software --force 