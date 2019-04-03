FROM alpine:3.9

ENV CONSUL_TEMPLATE_VERSION="0.20.0" \
  CONSUL_TEMPLATE_CHECKSUM="0b4b0badf095a1e97d4cf9d7ddd7facbe7a03780c89adb584b8c6d00294f2e61"


RUN apk --no-cache add curl caddy && \
  curl -Lo /tmp/consul-template.tgz https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz && \
  echo "${CONSUL_TEMPLATE_CHECKSUM}  /tmp/consul-template.tgz" | sha256sum -c - && \
  tar xzC /usr/bin/ -f /tmp/consul-template.tgz && \
  chmod +x /usr/bin/consul-template && \
  rm -f /tmp/consul-template.tgz && \
  adduser -h /tmp -s /bin/sh -DHS example

COPY docker/index.html.ctmpl /tmp/
COPY docker/consul-template.conf /consul-template.conf

USER example
EXPOSE 2015

CMD ["consul-template","-config=/consul-template.conf","-log-level=info"]
