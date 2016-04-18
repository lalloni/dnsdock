FROM alpine:3.3

ADD . /build

RUN \
apk -U add go git && \
cd /build && export REF="$(git describe --tags HEAD || git symbolic-ref -q --short HEAD)" && \
git clone -q https://github.com/tonistiigi/dnsdock.git /go/src/github.com/tonistiigi/dnsdock && \
cd /go/src/github.com/tonistiigi/dnsdock && (git checkout -q "${REF}" || git checkout -q "v${REF}") && \
GOPATH=/go go get github.com/tools/godep && \
GOPATH=/go /go/bin/godep go install -ldflags "-X main.version=${REF}" && \
mv -v /go/bin/dnsdock /dnsdock && apk del --purge go git && rm -rf /build /go /etc/ssl /var/cache/apk

ENTRYPOINT ["/dnsdock"]
