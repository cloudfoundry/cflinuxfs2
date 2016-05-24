RSpec.configure do |config|
  config.before(:all) do
    unless File.exist?("cflinuxfs2.tar.gz")
      puts "Running `make` to create cflinuxfs2.tar.gz"
			IO.popen('make') do |io|
				while (line = io.gets) do
					puts line
				end
			end
    end
    puts "Importing stacks/testing docker image created from cflinuxfs2.tar.gz"
    `docker import cflinuxfs2.tar.gz stacks/testing`
  end
end
