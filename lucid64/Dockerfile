FROM cloudfoundry/lucid64:minbase

ADD build /tmp/build
ADD assets /tmp/assets

RUN bash /tmp/build/plant-seed.sh
RUN bash /tmp/build/configure-locale-timezone.sh
RUN bash /tmp/build/install-packages.sh
RUN bash /tmp/build/install-ruby.sh 1.9.3-p484

# /app must exist so we can bind-mount it to /home/vcap in seed
RUN mkdir /app

RUN rm -rf /tmp/build
