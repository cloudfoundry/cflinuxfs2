FROM ubuntu:lucid

RUN mkdir -p /tmp

ADD build /tmp/build
ADD assets /tmp/assets

RUN bash /tmp/build/configure-locale-timezone.sh
RUN bash /tmp/build/install-packages.sh
RUN bash /tmp/build/install-ruby.sh 1.9.3-p551
RUN bash /tmp/build/configure-core-dump-directory.sh
RUN bash /tmp/build/configure-firstboot.sh
RUN bash -c '\
  cd /tmp; \
  wget http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz; \
  tar -zxvf yaml-0.1.6.tar.gz; \
  cd yaml-0.1.6; \
  ./configure; \
  make; \
  make install'

RUN rm -rf /tmp/*
