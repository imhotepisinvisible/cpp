FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -q -y \
    libsqlite3-dev \
    ruby \
    ruby-dev \
    build-essential \
  && gem install --no-ri --no-rdoc mime-types --version "< 3" \
  && gem install --no-ri --no-rdoc --conservative mailcatcher; exit 0 \
  && apt-get remove -y build-essential \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists

EXPOSE 1080 1025

ENTRYPOINT ["mailcatcher", "--smtp-ip=0.0.0.0", "--http-ip=0.0.0.0", "--foreground"]
