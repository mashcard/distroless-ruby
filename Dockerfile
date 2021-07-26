FROM ruby:3-buster as builder
ADD https://github.com/coord-e/magicpak/releases/download/v1.2.0/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
RUN chmod +x /usr/bin/magicpak
RUN /usr/bin/magicpak -v $(which ruby) /bundle
RUN curl https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | \
  tee /etc/apt/sources.list.d/postgres.list
RUN apt -y update && \
  apt -y install libpq-dev libjemalloc2 libxml2-dev libxslt-dev libffi-dev \
  && rm -rf /var/lib/apt/lists/*

FROM gcr.io/distroless/cc-debian10
LABEL org.opencontainers.iamge.authors="secure@brickdoc.com"
LABEL org.opencontainers.image.licenses = "Apache-2.0"
LABEL org.opencontainers.image.source = "https://github.com/brickdoc/distroless-ruby"
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
COPY --from=builder /bundle /.
COPY --from=builder /usr/lib/x86_64-linux-gnu/libpq* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjemalloc* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libxml* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libxslt* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libexslt* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libyaml* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libffi* /usr/lib/x86_64-linux-gnu/

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib

CMD ["/usr/local/bin/ruby", "-v"]