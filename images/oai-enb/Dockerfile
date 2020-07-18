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
    && ./build_oai -c --eNB -w USRP --verbose-compile 
	
ENV APP_ROOT=/opt/oai-enb
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}

COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
	
RUN cp openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem ${APP_ROOT}/bin/ \
    && cp openairinterface5g/cmake_targets/lte_build_oai/build/*.so* /lib64/ \
    && cd /lib64 \
    && ln -sf liboai_eth_transpro.so liboai_transpro.so \
    && ln -sf liboai_usrpdevif.so liboai_device.so \
    && ln -sf libuhd.so.3.13 libuhd.so.3 \
    && ln -sf libuhd.so.3 libuhd.so
	
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
