FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-ue" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com" \
      io.k8s.description="openairinterface5g UE $GIT_TAG." \
      io.openshift.tags="oai,ue" \
      io.openshift.non-scalable="true"
	  
ARG GIT_TAG=master

RUN apt-get update && apt-get install -y gcc g++ build-essential git curl wget \
 xxd linux-headers-5.3.0-1030-gcp iproute2 iputils-arping iputils-ping \
 iputils-tracepath bind9 

WORKDIR /root

RUN if [ "$EURECOM_PROXY" == true ]; then git config --global http.proxy http://:@proxy.eurecom.fr:8080; fi
RUN git clone --depth=1 --branch=$GIT_TAG https://gitlab.eurecom.fr/oai/openairinterface5g.git
COPY patches patches/
RUN patch -p1 -d openairinterface5g < patches/disable_building_nasmesh_and_rbtool.patch \
    && patch -p1 -d openairinterface5g < patches/0001-enable-sudoless-build.patch \
	&& patch -p1 -d openairinterface5g < patches/0002-modify-tar-command.patch	

RUN cd openairinterface5g/cmake_targets \
   && ./build_oai -I  --UE --install-system-files -w USRP
 
ENV APP_ROOT=/opt/oai-ue
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY /root/openairinterface5g/cmake_targets/lte_build_oai/build/lte-uesoftmodem ${APP_ROOT}/bin/
COPY /root/openairinterface5g/cmake_targets/lte_build_oai/build/*.so* /lib64/
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
