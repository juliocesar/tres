require 'rack'
require 'colorize'

module Tres
  class RackLogger
    def initialize(app, logger=nil)
      @app = app
      @logger = logger
    end

    def call(env)
      began_at = Time.now
      status, header, body = @app.call(env)
      header = ::Rack::Utils::HeaderHash.new(header)
      body = ::Rack::BodyProxy.new(body) { log(env, status, header, began_at) }
      [status, header, body]
    end

    private

    def log(env, status, header, began_at)
      now = Time.now
      length = extract_content_length(header)

      logger = @logger || env['rack.errors']
      # logger.write FORMAT % [
      #   env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
      #   env["REMOTE_USER"] || "-",
      #   now.strftime("%d/%b/%Y %H:%M:%S"),
      #   env["REQUEST_METHOD"],
      #   env["PATH_INFO"],
      #   env["QUERY_STRING"].empty? ? "" : "?"+env["QUERY_STRING"],
      #   env["HTTP_VERSION"],
      #   status.to_s[0..3],
      #   length,
      #   now - began_at ]
      logger.write Tres::OUTPUT_FORMAT % (
        "[%s] %s %s\n" % [
          colorized_status(status),
          env["REQUEST_METHOD"],
          env["PATH_INFO"]
        ]
      )
    end

    def extract_content_length(headers)
      value = headers['Content-Length'] or return '-'
      value.to_s == '0' ? '-' : value
    end

    def colorized_status status
      color = :green
      case status.to_s[0]
      when '3'
        color = :yellow
      when '4'
        color = :red
      end
      status.to_s[0..3].colorize(color)
    end
  end
end