# Using ubuntu 18 bionc as base image
FROM ubuntu:bionic

ARG GIT_TAG=latest
ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-build-base" \
      version="${GIT_TAG}" \
      io.k8s.description="Ubuntu base Image containing all build dependencies for openairinterface5g and openair-cn."

WORKDIR /root
RUN apt-get update && apt-get install -y \
        git make cmake gcc g++ autoconf automake bc bison flex libtool patch \
        libatlas-base-dev \
        libblas3 \
        libblas-dev \
		liblapack3 \
		liblapack-dev \
        libboost-dev \
        libbz2-dev \
        check \
        libelf-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libgmp-dev \
        libgnutls28-dev \
        guile-2.2-dev \
        linux-headers-generic \
        libasan2 \
        libconfig-dev \
        libevent-dev \
        libffi-dev \
        libgcrypt-dev \
        libidn11-dev \
        libidn2-dev  \
        libtool \
        libusb-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt-dev \
        libyaml-dev \
        lksctp-tools \
        libsctp-dev \
        liblz4-dev \
        libmariadbclient-dev \
        nettle-dev \
        openssh-client \
        openssh-server \
        openssl \
        libssl-dev \
        pkg-config \
        libprotobuf-dev \
        libprotobuf-c1 \
        protobuf-c-compiler \
        libprotobuf-c-dev \
        psmisc \
        python \
		python-dev \
		python-pip \
        python-docutils \
        python-requests \
        vim-common \
        liblzma-dev \
        zlib1g-dev \
        libforms-dev \
        libforms-bin \
		libuhd-dev \
		libuhd003.010.003\
		uhd-host \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --user mako pexpect

RUN if [ "$EURECOM_PROXY" == true ]; then git config --global http.proxy http://:@proxy.eurecom.fr:8080; fi

# build packages not in ubuntu repo
COPY patches patches/
COPY scripts scripts/
RUN chmod a+x scripts/build_missing_packages2 && scripts/build_missing_packages2
