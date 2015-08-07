FROM ubuntu:trusty

ADD build /tmp/build
ADD assets /tmp/assets

RUN bash /tmp/build/configure-locale-timezone.sh
RUN bash /tmp/build/install-packages.sh
RUN bash /tmp/build/install-ruby.sh 1.9.3-p547
RUN bash /tmp/build/configure-core-dump-directory.sh
RUN bash /tmp/build/configure-firstboot.sh

# create the vcap for garden and warden
RUN useradd -mU -s /bin/bash vcap
RUN mkdir /home/vcap/app
RUN chown vcap /home/vcap/app
RUN ln -s /home/vcap/app /app

RUN rm -rf /tmp/*
