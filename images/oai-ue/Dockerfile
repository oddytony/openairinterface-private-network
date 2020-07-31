FROM oai-enb-base

ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-ue" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com" \
      io.k8s.description="openairinterface5g UE $GIT_TAG." \
      io.openshift.tags="oai,ue" \
      io.openshift.non-scalable="true"
	  
WORKDIR /root

RUN cd openairinterface5g/cmake_targets \
   && ./build_oai -c --UE -w USRP --verbose-compile 
   

ENV APP_ROOT=/opt/oai-ue
ENV APP_DIR=/usr/local

COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/

RUN cp openairinterface5g/cmake_targets/lte_build_oai/build/lte-uesoftmodem ${APP_DIR}/bin/ \
    && cp openairinterface5g/cmake_targets/lte_build_oai/build/*.so* ${APP_DIR}/lib/ \
    && cd ${APP_DIR}/lib \
    && ln -sf liboai_eth_transpro.so liboai_transpro.so \
    && ln -sf liboai_usrpdevif.so liboai_device.so \
    && ln -sf libuhd.so.3.13 libuhd.so.3 \
    && ln -sf libuhd.so.3 libuhd.so
	
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd && \
    mkdir -p /dev/net && \
	mknod /dev/net/tun c 10 200 && \
	chmod 600 /dev/net/tun

# expose ports from ue.conf
EXPOSE 50000/udp 50001/udp

CMD ["/usr/local/bin/lte-uesoftmodem", \
    "-C", "2680000000", "-r", "25", "--nokrnmod", "1", \
    "-O", "/opt/oai-ue/etc/ue.conf"]
ENTRYPOINT ["/opt/oai-ue/bin/entrypoint.sh"]
