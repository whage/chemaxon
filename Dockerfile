# Use golang image for building the binary
FROM golang:1.14.4-buster
WORKDIR /go/src/chemaxon
COPY . /go/src/chemaxon
RUN make build

# Use a different, Ubuntu image for hosting the binary
FROM ubuntu:focal
COPY --from=0 /go/src/chemaxon/build/mirror /usr/local/bin/mirror
EXPOSE 80
ENTRYPOINT [ "mirror" ]
