FROM endial/base-alpine:v3.6

MAINTAINER Endial Fang ( endial@126.com )

ARG CERTBOT_VER=v0.17.0

RUN set -ex \
    && apk update \
    && BUILD_DEPS="py2-pip \
            gcc \
            musl-dev \
            python2-dev \
            libffi-dev \
            openssl-dev" \
    && apk add -U ${BUILD_DEPS} \
        tini \
        dialog \
        python \
        libssl1.0 \
    && pip install --no-cache virtualenv \
    && virtualenv --no-site-packages -p python2 /usr/certbot/venv \
    && /usr/certbot/venv/bin/pip install --no-cache-dir certbot==${CERTBOT_VER} idna==v2.5\
    && pip uninstall --no-cache-dir -y virtualenv \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* /root/.cache/pip

EXPOSE 80 443

VOLUME /etc/letsencrypt

ENTRYPOINT ["/sbin/tini","--","/usr/certbot/venv/bin/certbot"]
CMD ["--help"]
