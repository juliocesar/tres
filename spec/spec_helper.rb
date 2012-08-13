require 'tmpdir'
require File.join(File.dirname(__FILE__), *%w(.. lib tres))
require 'rspec'
require 'rake'
require 'ostruct'

Tres.quiet!

TMP       = Dir.tmpdir/'tres-tmp'
FIXTURES  = File.dirname(__FILE__)/'fixtures'
MEMLOGGER = Logger.new(StringIO.new)

FileUtils.rm_rf   TMP
FileUtils.mkdir_p TMP

Anagen = OpenStruct.new
Anagen.root = File.dirname(__FILE__)/'sample'
Anagen.build = Anagen.root/'build'
Anagen.build_templates = Anagen.build/'templates'
Anagen.build_js     = Anagen.build/'js'
Anagen.build_css    = Anagen.build/'css'
Anagen.build_index  = Anagen.build/'index.html'
Anagen.templates    = Anagen.root/'templates'
Anagen.templates_js = Anagen.build_js/'templates.js'

class String
  def read
    File.read self
  end

  def compile
    Tilt.new(self).render 
  end

  def escaped_compile
    compiler = Tres::TemplateCompiler.new :root => Anagen.root
    compiler.send :escape_js, Tilt.new(self).render
  end
end

def stub_listener!
  Listen.stub :to => mock(Listen::Listener, :change => 'true', :start => true)
end

def clean_build!
  FileUtils.rm_f  Anagen.build_index
  FileUtils.rm_f  Anagen.templates_js  
  FileUtils.rm_rf Anagen.build_templates
end

RSpec.configure do |config|
  config.color_enabled = true

  config.after :all do
    clean_build!
  end
end