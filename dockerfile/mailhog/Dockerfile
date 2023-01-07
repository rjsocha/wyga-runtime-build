#
# MailHog Dockerfile
#

FROM golang:1.18-alpine as builder

# Install MailHog:
RUN apk --no-cache add --virtual build-dependencies \
    git binutils \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go install github.com/mailhog/MailHog@latest \
  && strip -x /root/gocode/bin/MailHog
RUN mkdir -p /output/mailhog /output/sack \
  && cp /root/gocode/bin/MailHog /output/mailhog
COPY files/mailhog/wyga/docker-mailhog-entrypoint /output/usr/local/bin/docker-mailhog-entrypoint
COPY files/mailhog/wyga/wyga-entrypoint.sh /output/wyga-entrypoint.sh
COPY files/wyga/env-conf /output/usr/local/bin/env-conf
RUN adduser -D -u 1000 mailhog
RUN chmod +x /output/wyga-entrypoint.sh \
            /output/usr/local/bin/docker-mailhog-entrypoint \
            /output/usr/local/bin/env-conf \
    && mkdir /output/maildir \
    && chown mailhog:mailhog /output/maildir /output/sack \
    && ln -s /mailhog/MailHog /output/mailhog/mailhog

FROM alpine:3
COPY --from=builder /output/ /
RUN adduser -D -u 1000 mailhog
VOLUME /maildir
WORKDIR /mailhog
ENV PATH "$PATH:/mailhog"
USER mailhog
EXPOSE 8025 1025
ENTRYPOINT ["/wyga-entrypoint.sh"]
