FROM oai-build-base AS builder

ARG GIT_TAG=v1.1.1

WORKDIR /root

RUN if [ "$EURECOM_PROXY" == true ]; then git config --global http.proxy http://:@proxy.eurecom.fr:8080; fi
RUN git clone --depth=1 --branch=$GIT_TAG https://gitlab.eurecom.fr/oai/openairinterface5g.git
COPY patches patches/
RUN patch -p1 -d openairinterface5g < patches/disable_building_nasmesh_and_rbtool.patch \
    && patch -p1 -d openairinterface5g < patches/el8_support_ue_ip_module.patch
RUN cd openairinterface5g/cmake_targets \
    && ln -sf /usr/local/bin/asn1c_oai /usr/local/bin/asn1c \
    && ln -sf /usr/local/share/asn1c_oai /usr/local/share/asn1c \
    && ./build_oai -c --UE -w USRP --verbose-compile


FROM ubuntu:bionic
LABEL name="oai-ue" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com" \
      io.k8s.description="openairinterface5g UE $GIT_TAG." \
      io.openshift.tags="oai,ue" \
      io.openshift.non-scalable="true"

RUN apt-get update && apt-get install -y \
    libatlas-base-dev \
    libblas3 \
	libblas3gf \
    liblapack3 \
	libboost-all-dev \
	libconfig-dev \
    lksctp-tools \
    libprotobuf-c1 \
    libforms-bin \
	lksctp-tools \
	iproute \
	iputils-arping \
	iputils-ping \
	iputils-tracepath \
	bind9-dnsutils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 
 
ENV APP_ROOT=/opt/oai-ue
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY --from=builder /root/openairinterface5g/cmake_targets/lte_build_oai/build/lte-uesoftmodem ${APP_ROOT}/bin/
COPY --from=builder /root/openairinterface5g/cmake_targets/lte_build_oai/build/*.so* /lib64
COPY --from=builder /usr/local/lib64 /lib64
COPY --from=builder /usr/local/bin/uhd_* /usr/local/bin
COPY --from=builder /usr/local/share/uhd /usr/local/share/uhd
RUN cd /lib64 \
    && ln -sf liboai_eth_transpro.so liboai_transpro.so \
    && ln -sf liboai_usrpdevif.so liboai_device.so \
    && ln -sf libuhd.so.3.13 libuhd.so.3 \
    && ln -sf libuhd.so.3 libuhd.so
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
USER 10001
WORKDIR ${APP_ROOT}

# expose ports from ue.conf
EXPOSE 50000/udp 50001/udp

CMD ["/opt/oai-ue/bin/lte-uesoftmodem", \
    "-C", "2680000000", "-r", "25", "--nokrnmod", "1", \
    "-O", "/opt/oai-ue/etc/ue.conf"]
ENTRYPOINT ["/opt/oai-ue/bin/entrypoint.sh"]
