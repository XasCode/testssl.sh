FROM alpine:3.16

RUN apk update && \
    apk upgrade && \
    apk add --update bash procps drill git coreutils libidn python3 curl which socat openssl xxd && \
    rm -rf /var/cache/apk/* && \
    addgroup testssl && \
    adduser -G testssl -g "testssl user" -s /bin/bash -D testssl && \
    ln -s /home/testssl/testssl.sh /usr/local/bin/ && \
    mkdir -m 755 -p /home/testssl/etc /home/testssl/bin

USER testssl
WORKDIR /home/testssl/

RUN cd /home/testssl && curl -sSL https://sdk.cloud.google.com | bash

RUN /home/testssl/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true

ENV PATH $PATH:/home/testssl/google-cloud-sdk/bin

COPY --chown=testssl:testssl etc/. /home/testssl/etc/
COPY --chown=testssl:testssl bin/. /home/testssl/bin/
COPY --chown=testssl:testssl testssl.sh /home/testssl/
COPY --chown=testssl:testssl script.sh /home/testssl/

RUN chmod +x /home/testssl/script.sh

CMD ["/home/testssl/script.sh"]
