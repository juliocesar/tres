# Rack config file for deployments. For local web development, use the Tres
# server.

use Rack::Static,
  :urls => %w(/stylesheets /font /javascripts),
  :root => Dir.pwd + '/build'

run lambda { |env|
  [ 200, { 'Content-Type' => 'text/html' }, File.open('build/index.html') ]
}
