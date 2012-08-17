require 'rack'
require File.dirname(__FILE__) + '/rack_logger'

module Tres
  class Server
    attr_accessor :app

    def initialize app
      @app = app
      @static_server = Rack::File.new @app.root/'build'
    end

    def call env
      response = serve_static env
      response = serve_asset env if not_found?(response)
      response = serve_index if not_found?(response)
      response
    end

    def to_rack_app
      me = self
      Rack::Builder.new do
        use ::Tres::RackLogger
        use Rack::Lint
        run me
      end      
    end

    private
    def serve_static env
      @static_server.call env
    end

    def serve_asset env
      @app.asset_packager.sprockets.call env
    end

    def serve_index 
      [ 200, { 'Content-Type' => 'text/html' }, File.open(@app.root/'build'/'index.html') ]
    end

    def not_found
      [ 404, { 'Content-Type' => 'text/plain' }, ['Not found'] ]
    end

    def not_found? response
      response[0] == 404
    end
  end
end