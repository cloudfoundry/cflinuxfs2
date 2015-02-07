set -e -x

# if git --version &>/dev/null; then
#  echo "please run install-packages.sh"
#  exit 1
# fi

if ! [ -z "$RUBY_VERSION" ]; then
  echo "please run install-ruby.sh"
  exit 1
fi

gem install bundler

git clone http://github.com/cloudfoundry/warden.git

#setup warden's default rootfs
(
  cd /warden/warden
  bundle install && bundle exec rake setup[config/linux.yml]
)
