require 'rack'
require '../lib/tres'

app = Tres::App.new File.dirname(__FILE__), false

module StaticApp ; extend self
  ROOT = Dir.pwd + '/build'
  FileServer = Rack::File.new ROOT

  def call(env)
    # Serve the file if it exists
    resp = FileServer.call(env)
    return cache(resp) unless not_found?(resp)

    # If path ends with '/' then append 'index.html' and serve that file if it
    # exists otherwise strip the trailing slash and redirect
    if env['PATH_INFO'][-1] == ?/
      resp = FileServer.call(rewrite_path(env, 'index.html'))
      resp = not_found?(resp) ? redirect(path[0...-1]) : cache(resp)
      return resp
    end

    # Append '.html' and serve that file if it exists
    resp = FileServer.call(rewrite_path(env, '.html'))
    return cache(resp) unless not_found?(resp)

    # Serve not found
    not_found
  end

  def rewrite_path(env, newpath)
    env.merge('PATH_INFO' => env['PATH_INFO'] + newpath)
  end

  def cache(resp)
    # resp[1]['Cache-Control'] = "public, max-age=#{15 * 60}" # 15min
    resp
  end

  def redirect(path)
    [ 301, { 'Content-Type' => 'text/plain', 'Location' => path }, ["redirecting to #{path}"] ]
  end

  def not_found
    not_found_file = ROOT + '/404.html'
    body = File.exists?(not_found_file) ? File.open(not_found_file) : ['Not Found']
    [ 404, { 'Content-Type' => 'text/plain' }, body ]
  end

  def not_found?(resp)
    resp[0] == 404
  end
end

map '/assets' do
  run app.packager.sprockets
end

run StaticApp
