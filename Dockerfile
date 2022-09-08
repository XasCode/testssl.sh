FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

RUN apk update && \
    apk upgrade && \
    apk add --update openjdk7-jre bash procps drill git coreutils libidn python3 curl which socat openssl xxd && \
    rm -rf /var/cache/apk/* && \
    addgroup testssl && \
    adduser -G testssl -g "testssl user" -s /bin/bash -D testssl && \
    ln -s /home/testssl/testssl.sh /usr/local/bin/ && \
    mkdir -m 755 -p /home/testssl/etc /home/testssl/bin && \
    gcloud components install app-engine-java kubectl && \
    gcloud config set component_manager/disable_update_check true

USER testssl
WORKDIR /home/testssl/

COPY --chown=testssl:testssl etc/. /home/testssl/etc/
COPY --chown=testssl:testssl bin/. /home/testssl/bin/
COPY --chown=testssl:testssl testssl.sh /home/testssl/
COPY --chown=testssl:testssl script.sh /home/testssl/

RUN chmod +x /home/testssl/script.sh

ENTRYPOINT ["/bin/bash","/home/testssl/script.sh"]
