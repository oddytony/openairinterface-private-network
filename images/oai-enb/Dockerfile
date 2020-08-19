FROM oai-enb-base

ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-enb" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openairinterface5g eNB $GIT_TAG." \
      io.openshift.tags="oai,enb" \
      io.openshift.non-scalable="true"

WORKDIR /root

RUN cd openairinterface5g/cmake_targets \
    && ./build_oai -c --eNB --verbose-compile 
	
ENV APP_ROOT=/opt/oai-enb
ENV APP_DIR=/usr/local

COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
	
RUN cp openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem ${APP_DIR}/bin/ \
    && cp openairinterface5g/cmake_targets/lte_build_oai/build/*.so* ${APP_DIR}/lib/ \
    && cd ${APP_DIR}/lib \
    && ln -sf liboai_eth_transpro.so liboai_transpro.so \
    && ln -sf librfsimulator.so liboai_device.so 
    #&& ln -sf libuhd.so.3.13 libuhd.so.3 \
    #&& ln -sf libuhd.so.3 libuhd.so
	
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd 

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
EXPOSE 4043/tcp

CMD ["/usr/local/bin/lte-softmodem", "--basicsim", "-O", "/opt/oai-enb/etc/enb.conf"]
ENTRYPOINT ["/opt/oai-enb/bin/entrypoint.sh"]
