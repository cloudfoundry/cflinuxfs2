require 'spec_helper'

describe "Golang" do
  it 'installs go1.7 to the correct location' do
    go_command = 'GOROOT=/usr/local/go1.7 /usr/local/go1.7/bin/go version'
    go_command_output =  `docker run stacks/testing /bin/bash -c "#{go_command}" 2>&1`

    expect(go_command_output).to match /go version go1\.7(.*) linux\/amd64/
  end

  it 'does not add go1.7 to the PATH' do
    go_command = 'go version'
    go_command_output =  `docker run stacks/testing /bin/bash -c "#{go_command}" 2>&1`

    expect(go_command_output).to match /\/bin\/bash: go: command not found/
  end
end
