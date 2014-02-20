FROM crohr/ubuntu:lucid

ADD assets/etc/hosts /etc/hosts
ADD assets/etc/timezone /etc/timezone
ADD assets/etc/default/locale /etc/default/locale

ADD build.sh /tmp/
RUN bash /tmp/build.sh

RUN rm -rf /tmp/build.sh
