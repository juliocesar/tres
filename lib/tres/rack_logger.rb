require 'rack'
require 'colorize'

module Tres
  class RackLogger < ::Rack::CommonLogger
    private
    def log env, status, header, began_at
      now = Time.now
      length = extract_content_length(header)

      logger = @logger || env['rack.errors']
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