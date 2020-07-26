FROM oai-spgw-base
LABEL name="oai-spgwu" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn-cups S/P-GW-U $GIT_TAG" \
      io.openshift.tags="oai,spgwu" \
      io.openshift.non-scalable="true"

WORKDIR /root

RUN cd openair-cn-cups/build/scripts \
    && ./build_spgwu -c -v -b RelWithDebInfo -j

ENV APP_ROOT=/opt/oai-spgwu
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
#USER 10001
WORKDIR ${APP_ROOT}

# expose ports
EXPOSE 2152/udp 8805/udp

CMD ["/usr/local/bin/spgwu", "-c", "/opt/oai-spgwu/etc/spgw_u.conf"]
ENTRYPOINT ["/opt/oai-spgwu/bin/entrypoint.sh"]
