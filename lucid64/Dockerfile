FROM crohr/ubuntu:lucid

ADD build /tmp/build
ADD assets /tmp/assets

RUN bash /tmp/build/configure-locale-timezone.sh
RUN bash /tmp/build/install-packages.sh
RUN bash /tmp/build/install-ruby.sh

# create /app so we can bind-mount over it; / cannot be assumed to be writable
RUN mkdir /app

RUN rm -rf /tmp/build
