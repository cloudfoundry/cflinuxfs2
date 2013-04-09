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

git "/warden" do
  repository "git://github.com/cloudfoundry/warden.git"
  reference "master"
  action :sync
end

