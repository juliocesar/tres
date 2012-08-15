require 'rack'
require File.dirname(__FILE__) + '/rack_logger'

module Tres
  class Server
    def self.build app
      me = self
      Rack::Builder.new do
        use ::Tres::RackLogger
        use Rack::Lint
        run me.new(app)
      end
    end

    def initialize app
      @app = app
    end

    def call env
      if env["PATH_INFO"] =~ /stylesheets/ or env["PATH_INFO"] =~ /javascripts/
        response = @app.asset_packager.sprockets.call env
        return response
      end
      index = File.open @app.root/'build'/'index.html'
      [ 200, { 'Content-Type' => 'text/html' }, index ]
    end

    private
    def not_found? response
      response[0] == 404
    end

    def not_found
      [ 404, { 'Content-Type' => 'text/plain' }, ['Not found'] ]
    end
  end
end