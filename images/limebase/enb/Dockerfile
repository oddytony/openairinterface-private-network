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

RUN git clone --depth=1 --branch=lime2 https://github.com/oddytony/openairinterface-private-network.git

RUN cd openairinterface-private-network/source/cmake_targets \
    && ./build_oai -I --install-system-files -w LMSSDR --install-optional-packages

RUN cd openairinterface-private-network/source/cmake_targets \
    && ./build_oai --eNB -w LMSSDR -I
    

