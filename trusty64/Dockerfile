FROM cloudfoundry/trusty64:minbase

ADD build /tmp/build
ADD assets /tmp/assets

RUN bash /tmp/build/configure-locale-timezone.sh
RUN bash /tmp/build/install-packages.sh
RUN bash /tmp/build/install-ruby.sh 1.9.3-p547
RUN bash /tmp/build/configure-core-dump-directory.sh
RUN bash /tmp/build/configure-firstboot.sh

RUN rm -rf /tmp/build
