require 'sinatra'
require 'listen'

set :root => File.expand_path(File.dirname(__FILE__)) + '/anagen',
    :public_folder => Sinatra::Application.root

get '/*' do
  File.read Sinatra::Application.root + '/index.html'
end