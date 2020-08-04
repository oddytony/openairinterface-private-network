FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-enb-base" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com" \
      io.k8s.description="openairinterface5g UE $GIT_TAG." \
      io.openshift.tags="oai,ue" \
      io.openshift.non-scalable="true"
	  
ARG GIT_TAG=master

RUN apt-get update && apt-get install -y gcc g++ build-essential git curl wget \
 xxd linux-headers-5.3.0-1032-gcp iproute2 iputils-arping iputils-ping \
 iputils-tracepath bind9 

WORKDIR /root

RUN if [ "$EURECOM_PROXY" == true ]; then git config --global http.proxy http://:@proxy.eurecom.fr:8080; fi
RUN git clone --depth=1 --branch=$GIT_TAG https://gitlab.eurecom.fr/oai/openairinterface5g.git
COPY patches patches/
RUN patch -p1 -d openairinterface5g < patches/0001-disable-nasmesh-and-rbtool-build.patch \
    && patch -p1 -d openairinterface5g < patches/0001-enable-sudoless-build.patch \
	&& patch -p1 -d openairinterface5g < patches/0002-disable-sched-fifo-fail-exits.patch \
	&& patch -p1 -d openairinterface5g < patches/0002-modify-tar-command.patch	

RUN cd openairinterface5g/cmake_targets \
    && ./build_oai -I --install-system-files -w USRP
