FROM alpine:3.8

MAINTAINER Lev Goncharov <lev@goncharov.xyz>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openssl && \
    apk add --update openvpn \
      bash libintl inotify-tools openvpn-auth-pam pamtester && \
    apk add --virtual temppkg gettext &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del temppkg && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV OVPN_TEMPLATE $OPENVPN/templates/openvpn.tmpl
ENV OVPN_CONFIG $OPENVPN/openvpn.conf

ENV OVPN_CIPHER "AES-256-CBC"
ENV OVPN_TLS_CIPHER "TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256:TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256:TLS-ECDHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-CBC-SHA256"

ENV EASYRSA_PKI $OPENVPN/pki

# Some PKI scripts.
ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Initialisation scripts and default template
COPY *.sh /sbin/
COPY openvpn.tmpl $OVPN_TEMPLATE

CMD ["/sbin/entrypoint.sh"]
