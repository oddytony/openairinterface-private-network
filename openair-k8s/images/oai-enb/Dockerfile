FROM oai-build-base AS builder

# ARG GIT_TAG=v1.1.1

WORKDIR /root

RUN if [ "$EURECOM_PROXY" == true ]; then git config --global http.proxy http://:@proxy.eurecom.fr:8080; fi

RUN git clone --depth=1 https://gitlab.eurecom.fr/oai/openairinterface5g.git
COPY patches patches/
RUN patch -p1 -d openairinterface5g < patches/0001-disable-nasmesh-and-rbtool-build.patch \
    && patch -p1 -d openairinterface5g < patches/0002-disable-sched-fifo-fail-exits.patch \
	&& patch -p1 -d openairinterface5g < patches/0003-remove-unfound-library.patch 
RUN cd openairinterface5g/cmake_targets \
    && ln -sf /usr/local/bin/asn1c_oai /usr/local/bin/asn1c \
    && ln -sf /usr/local/share/asn1c_oai /usr/local/share/asn1c \
    && ./build_oai -c --eNB -w USRP --verbose-compile

FROM ubuntu:bionic

LABEL name="oai-enb" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openairinterface5g eNB $GIT_TAG." \
      io.openshift.tags="oai,enb" \
      io.openshift.non-scalable="true"

RUN apt-get update && apt-get install -y \
       iproute2 \
	   iputils-arping \
	   iputils-ping \
	   iputils-tracepath \
	   bind9 \
       libboost-all-dev \
       libconfig-dev \
       lksctp-tools \
       libprotobuf-c1 \
       libforms-bin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

ENV APP_ROOT=/opt/oai-enb
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY --from=builder /root/openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem ${APP_ROOT}/bin/
COPY --from=builder /root/openairinterface5g/cmake_targets/lte_build_oai/build/*.so* /lib64/
COPY --from=builder /usr/local/bin/uhd_* /usr/local/bin/
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

# S1U, GTP/UDP
EXPOSE 2152/udp 
EXPOSE 22100/tcp
# S1C, SCTP/UDP
EXPOSE 36412/udp
# X2C, SCTP/UDP
EXPOSE 36422/udp 
# IF5 / ORI (control)
EXPOSE 50000/udp
# IF5 / ECPRI (data)
EXPOSE 50001/udp

CMD ["/opt/oai-enb/bin/lte-softmodem", "-O", "/opt/oai-enb/etc/enb.conf"]
ENTRYPOINT ["/opt/oai-enb/bin/entrypoint.sh"]
