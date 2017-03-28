RSpec.configure do |config|
  config.color = true
  config.tty = true

  config.before(:all) do
    unless File.exist?("cflinuxfs2.tar.gz")
      puts "Running `make` to create cflinuxfs2.tar.gz"
			IO.popen('make') do |io|
				while (line = io.gets) do
					puts line
				end
			end
    end
    puts "Importing cflinuxfs2/testing docker image created from cflinuxfs2.tar.gz"
    `docker import cflinuxfs2.tar.gz cflinuxfs2/testing`
  end
end
