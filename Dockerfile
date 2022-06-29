# Build go
FROM golang:1.18.1-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download && \
    go env -w GOFLAGS=-buildvcs=false && \
    go build -v -o Aiko -trimpath -ldflags "-s -w -buildid=" ./main

# Release
FROM alpine
RUN apk --update --no-cache add tzdata ca-certificates && \
    cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && \
    mkdir /etc/Aiko/
COPY --from=builder /app/Aiko /usr/local/bin

ENTRYPOINT [ "Aiko", "--config", "/etc/Aiko/aiko.yml"]