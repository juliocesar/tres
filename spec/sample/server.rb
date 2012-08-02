require 'sinatra'
require '../lib/tres'

set :root           => File.expand_path(File.dirname(__FILE__)),
    :public_folder  => Sinatra::Application.root + '/public'


@app = Tres::App.new File.dirname(__FILE__), false

get '/*' do
  File.read Sinatra::Application.public_folder + '/index.html'
end
