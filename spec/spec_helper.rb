require 'tmpdir'
require File.join(File.dirname(__FILE__), *%w(.. lib tres))
require 'rspec'
require 'rake'
require 'json/pure'

Tres.quiet!

RSpec.configure do |config|
  config.before :all do
    TMP = Dir.tmpdir/'tres-tmp' unless defined?(TMP)
    FileUtils.rm_rf   TMP
    FileUtils.mkdir_p TMP
  end

  config.before :each do
    FileUtils.rm_rf TMP/'temp'
    @app = Tres::App.new TMP/'temp'
  end
end
