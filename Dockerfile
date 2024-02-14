# Birdwatcher - Your friendly alice looking glass data source

FROM golang:1.21.1-alpine3.18 AS builder

WORKDIR /src/birdwatcher
ADD vendor go.mod go.sum ./
RUN go mod download && go mod verify

# Add sourcecode
ADD . .

# Build birdwatcher
RUN CGO_ENABLED=0 GOOS=linux go build -o /src/birdwatcher/birdwatcher-linux-amd64
# RUN make linux_static

FROM alpine:3.18

COPY --from=builder /src/birdwatcher/birdwatcher-linux-amd64 /usr/bin/birdwatcher
ADD etc/birdwatcher/birdwatcher.conf /etc/birdwatcher/birdwatcher.conf

RUN apk add --no-cache bird \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

EXPOSE 29184/tcp
EXPOSE 29186/tcp

ENTRYPOINT ["/usr/bin/birdwatcher", "-config", "/etc/birdwatcher/birdwatcher.conf"]
