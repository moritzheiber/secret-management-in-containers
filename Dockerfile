FROM alpine:3.5

RUN apk --no-cache add curl && \
  curl -L https://github.com/mholt/caddy/releases/download/v0.9.5/caddy_linux_amd64.tar.gz -so - | tar xzC /usr/bin/ -f - && \
  curl -L https://releases.hashicorp.com/consul-template/0.18.1/consul-template_0.18.1_linux_amd64.tgz -so - | tar xzC /usr/bin/ -f - && \
  chmod +x /usr/bin/caddy_linux_amd64 /usr/bin/consul-template

COPY docker/index.html.ctmpl /tmp/
COPY docker/consul-template.conf /consul-template.conf

EXPOSE 2015

CMD ["consul-template","-config=/consul-template.conf"]
