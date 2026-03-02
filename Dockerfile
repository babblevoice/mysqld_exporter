FROM --platform=$BUILDPLATFORM alpine:3.23 AS builder
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

WORKDIR /usr/src/mysqld_exporter
COPY . .

RUN apk add --no-cache git make musl-dev go

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o mysqld_exporter .

FROM alpine:3.23 AS app

COPY --from=builder /usr/src/mysqld_exporter/mysqld_exporter /bin/mysqld_exporter

EXPOSE 9104

USER nobody

CMD [ "/bin/mysqld_exporter" ]