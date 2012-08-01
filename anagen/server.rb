require 'sinatra'
require 'listen'
require 'sprockets'
require 'pathname'

set :root           => File.expand_path(File.dirname(__FILE__)),
    :public_folder  => Sinatra::Application.root + '/public'


ROOT    = Pathname(File.dirname(__FILE__))
LOGGER  = Logger.new(STDOUT)
BUILD   = ROOT.join('build')

sprockets = Sprockets::Environment.new(ROOT) do |env| env.logger = LOGGER end






def compile_assets modified, added, removed
  puts "HERE"  
end

def start_watcher
  # return if @watcher
  @watcher = Listen.to('sass', 'coffeescripts', :latency => 0.5, :force_polling => true)
  @watcher.change do |*args|
    compile_assets *args
  end
  @watcher.start false
end

get '/*' do
  File.read Sinatra::Application.public_folder + '/index.html'
end

start_watcher