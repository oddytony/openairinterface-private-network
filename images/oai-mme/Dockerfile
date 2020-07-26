FROM oai-epc-base

LABEL name="oai-mme" \
      version="$GIT_TAG" \
      maintainer="Ighagbon Anthony O <signormca@yahoo.com>" \
      io.k8s.description="openair-cn MME $GIT_TAG." \
      io.openshift.tags="oai,mme" \
      io.openshift.non-scalable="true"
	  
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root

RUN cd openair-cn/scripts \
    && OPENAIRCN_DIR=$(dirname $(pwd)) ./build_mme -c -v -b Debug

ENV APP_ROOT=/opt/oai-mme
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
COPY scripts ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
#USER 10001
WORKDIR ${APP_ROOT}

# expose ports
EXPOSE 3870/tcp 5870/tcp 2123/udp

VOLUME ["${APP_ROOT}/certs"]

CMD ["/usr/local/bin/mme", "-c", "/opt/oai-mme/etc/mme.conf"]
ENTRYPOINT ["/opt/oai-mme/bin/entrypoint.sh"]
