FROM oai-epc-base

ARG DEBIAN_FRONTEND=noninteractive

LABEL name="oai-hss" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony <signormca@yahoo.com>" \
      io.k8s.description="openair-cn HSS $GIT_TAG." \
      io.openshift.tags="oai,hss" \
      io.openshift.non-scalable="true" \
      io.openshift.wants="mariadb"

ARG GIT_TAG=master 

WORKDIR /root

RUN cd openair-cn/scripts \
    && OPENAIRCN_DIR=$(dirname $(pwd)) ./build_hss_rel14 -v

ENV APP_ROOT=/opt/oai-hss
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}

COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
COPY certs ${APP_ROOT}/certs/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

WORKDIR ${APP_ROOT}

# expose ports configured in hss_fd.conf
EXPOSE 9042/tcp 5868/tcp 9080/tcp 9081/tcp

VOLUME ["${APP_ROOT}/certs"]

ENTRYPOINT ["/opt/oai-hss/bin/entrypoint.sh"]

CMD ["/usr/local/bin/oai_hss", "-j", "/opt/oai-hss/etc/hss_rel14.json"]
