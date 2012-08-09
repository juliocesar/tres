require 'tmpdir'
require File.join(File.dirname(__FILE__), *%w(.. lib tres))
require 'rspec'
require 'rake'

Tres.quiet!

TMP          = Dir.tmpdir/'tres-tmp'
SAMPLE_PATH  = Pathname(File.dirname(__FILE__)/'sample')
BUILD        = SAMPLE_PATH.to_s/'build'
TEMPLATES    = SAMPLE_PATH.to_s/'templates'
TEMPLATES_JS = BUILD.to_s/'js'/'templates.js'
FIXTURES     = File.dirname(__FILE__)/'fixtures'
MEMLOGGER    = Logger.new(StringIO.new)

FileUtils.rm_rf   TMP
FileUtils.mkdir_p TMP

def stub_listener!
  Listen.stub :to => mock(Listen::Listener, :change => 'true', :start => true)
end

def compile template
  Tilt.new(template).render
end

RSpec.configure do |config|
  config.color_enabled = true
end
