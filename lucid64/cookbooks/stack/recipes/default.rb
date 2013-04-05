RUBY_BUILD_DIR = "tmp/ruby-build"
ROOTFS_PATH = "/tmp/warden/rootfs"
WARDEN_PATH = "/warden"
ROOTFS_PACKAGE_PATH = "/vagrant/rootfs.tgz"
RUBY_VERSION = "1.9.3-p392"

packages = %w[
  ruby1.9.3
  debootstrap
  build-essential
  quota
]

packages.each do |package_name|
  package package_name do
    action :install
  end
end

gem_package "bundler" do
  action :install
  gem_binary "/usr/bin/gem"
end

git WARDEN_PATH do
  repository "git://github.com/cloudfoundry/warden.git"
  reference "master"
  action :sync
end

execute "setup default rootfs" do
  cwd "#{WARDEN_PATH}/warden"
  command "bundle install && bundle exec rake setup[config/linux.yml]"
  creates ROOTFS_PATH
  action :run
end

execute_in_chroot "update package list" do
  root_dir ROOTFS_PATH
  command "apt-get update"
end

container_packages = %w[
  zlib1g-dev
  unzip
  curl
]

execute_in_chroot "install packages" do
  root_dir ROOTFS_PATH
  command "apt-get --yes install #{container_packages.join(" ")}"
end

git "#{ROOTFS_PATH}/#{RUBY_BUILD_DIR}" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :sync
end

execute_in_chroot "install ruby" do
  prefix = "/usr/local"

  root_dir ROOTFS_PATH
  command [
    "cd #{RUBY_BUILD_DIR}",
    "PREFIX=#{prefix} ./install.sh",
    "#{prefix}/bin/ruby-build #{RUBY_VERSION} /usr"
  ].join(' && ')
  creates "#{ROOTFS_PATH}/usr/bin/ruby"
end

execute "packages rootfs" do
  command "tar czf #{ROOTFS_PACKAGE_PATH} *"
  cwd ROOTFS_PATH
end

