require 'spec_helper'
require 'Tempfile'

describe "ImageMagick" do
  let(:exploit_script_name) { "exploit.sh" }
  let(:exploit_script)      { Tempfile.new(exploit_script_name, ENV['HOME']) }
  let(:exploit_output)      { `docker run -v #{exploit_script.path}:/#{exploit_script_name} stacks/testing /bin/bash -c /#{exploit_script_name} 2>&1` }

  before do
    exploit_script.write("#{exploit_setup}\n#{exploit_command}")
    exploit_script.close
    File.chmod(0755, exploit_script.path)
  end

  after { exploit_script.unlink }

  context "pipe character does not execute subsequent commands" do
    let(:exploit_setup) {
      <<~SETUP
         tee exploit.mvg > /dev/null <<EOF
         push graphic-context
         viewbox 0 0 640 480
         image copy 200,200 100,100 "|echo EXPLOITED > /tmp/exploit.txt;"
         pop graphic-context
         EOF
         SETUP
    }
    let(:exploit_command) {
      <<~EXPLOIT
         convert exploit.mvg out.png; cat "/tmp/exploit.txt"
         EXPLOIT
    }

    it "does not cause code execution" do
      expect(exploit_output).to include("no decode delegate for this image format")
      expect(exploit_output).to_not include("EXPLOITED")
    end
  end

  context "insufficient shell character filtering" do
    let(:exploit_setup) { "echo EXPLOIT EXPLOITED > /tmp/secret.txt" }
    let(:exploit_command) {
      <<~EXPLOIT
         convert 'https://example.com"; cat "/tmp/secret.txt' out.png
         EXPLOIT
    }

    it "does not cause code execution" do
      expect(exploit_output).to include("not authorized")
      expect(exploit_output).to_not include("EXPLOIT EXPLOITED")
    end
  end

  context "external file inclusion" do
    let(:exploit_setup) {
      <<~SETUP
         tee exploit.mvg > /dev/null <<EOF
         push graphic-context
         viewbox 0 0 640 480
         fill 'url(http://example.com/)'
         pop graphic-context
         EOF
         SETUP
    }
    let(:exploit_command) { "convert exploit.mvg out.png" }

    it "does not make http requests" do
      expect(exploit_output).to include("no images defined `out.png'")
      expect(exploit_output).to_not include("no data returned `http://example.com'")
    end
  end

  context "using the 'ephemeral' pseudo protocol" do
    let(:exploit_setup) {
      <<~SETUP
         touch /tmp/delete.txt

         tee exploit.mvg > /dev/null <<EOF
         push graphic-context
         viewbox 0 0 640 480
         image over 0,0 0,0 'ephemeral:/tmp/delete.txt'
         popgraphic-context
         EOF
         SETUP
    }
    let(:exploit_command) {
      <<~EXPLOIT
         convert exploit.mvg out.png
         ls -l /tmp/delete.txt
         EXPLOIT
    }

    it "does not delete specified files" do
      expect(exploit_output).to include("-rw-r--r--")
      expect(exploit_output).to include("/tmp/delete.txt")
      expect(exploit_output).to_not include("cannot access /tmp/delete.txt: No such file or directory")
    end
  end

  context "using the 'msl' pseudo protocol" do
    let(:exploit_setup) {
      <<~SETUP
         convert -size 2x2 canvas:khaki /tmp/malicious.gif
         echo "irreplacable content" > /tmp/irreplacable.txt

         tee /tmp/msl.txt > /dev/null <<EOF
         <?xml version="1.0" encoding="UTF-8"?>
         <image>
         <read filename="/tmp/malicious.gif" />
         <write filename="/tmp/irreplacable.txt" />
         </image>
         EOF

         tee file_move.mvg > /dev/null <<EOF
         push graphic-context
         viewbox 0 0 640 480
         image over 0,0 0,0 'msl:/tmp/msl.txt'
         popgraphic-context
         EOF
         SETUP
    }
    let(:exploit_command) {
      <<~EXPLOIT
         convert file_move.mvg out.png
         cat /tmp/irreplacable.txt
         EXPLOIT
    }

    it "does not move files" do
      expect(exploit_output).to include("irreplacable content")
      expect(exploit_output).to_not include("khaki")
    end
  end

  context "using the 'label' pseudo protocol" do
    let(:exploit_setup) {
      <<~SETUP
         echo "234" > /tmp/secrets.txt

         tee file_read.mvg > /dev/null <<EOF
         push graphic-context
         viewbox 0 0 100 32
         image over 4,4 0,0 'label:@/tmp/secrets.txt'
         pop graphic-context
         EOF

         apt-get install -y gocr > /dev/null
         SETUP
    }
    let(:exploit_command) {
      <<~EXPLOIT
         convert file_read.mvg out.png
         gocr out.png
         EXPLOIT
    }

    it "does not display the secrets as a text label in the generated image" do
      expect(exploit_output).to include("no decode delegate for this image format `file_read.mvg'")
      expect(exploit_output).to include("out.png - No such file or directory")
      expect(exploit_output).to_not include("234")
    end
  end
end
