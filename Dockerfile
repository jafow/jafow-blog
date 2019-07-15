FROM alpine:3.10


RUN apk update && apk add curl bash rsync tar openssh
# get hugo
RUN curl -sSL -o hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_0.55.6_Linux-64bit.tar.gz \
    && tar -xzf hugo.tar.gz -C /usr/local/bin/

COPY . /home/hugouser/

RUN mkdir -p /home/hugouser/hugo_cache \
    && /usr/local/bin/hugo -s /home/hugouser --cacheDir /home/hugouser/hugo_cache \
    && addgroup -S hugouser && adduser -S hugouser -G hugouser -h hugouser \
    && chown -R hugouser /home/hugouser

USER hugouser

WORKDIR /home/hugouser

CMD ["hugo"]
