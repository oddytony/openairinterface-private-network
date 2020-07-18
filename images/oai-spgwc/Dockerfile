FROM oai-spgw-base

LABEL name="oai-spgwc" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn-cups S/P-GW-C $GIT_TAG" \
      io.openshift.tags="oai,spgwc" \
      io.openshift.non-scalable="true"
 
WORKDIR /root

RUN cd openair-cn-cups/build/scripts \
    && ./build_spgwc -c -v -f -b RelWithDebInfo -j 

ENV APP_ROOT=/opt/oai-spgwc
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
#USER 10001
WORKDIR ${APP_ROOT}

# expose ports
EXPOSE 2123/udp 8805/udp

CMD ["/usr/local/bin/spgwc", "-c", "/opt/oai-spgwc/etc/spgw_c.conf" ]
ENTRYPOINT ["/opt/oai-spgwc/bin/entrypoint.sh"]

