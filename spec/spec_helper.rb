require 'tmpdir'
require File.join(File.dirname(__FILE__), *%w(.. lib tres))
require 'rspec'
require 'rake'

Tres.quiet!

TMP = Dir.tmpdir/'tres-tmp'

FileUtils.rm_rf   TMP
FileUtils.mkdir_p TMP

def stub_listener!
  Listen.stub :to => mock(Listen::Listener, :change => 'true', :start => true)
end

RSpec.configure do |config|
  config.color_enabled = true
end
