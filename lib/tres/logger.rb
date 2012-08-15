require 'logger'

module Tres
  class Logger < ::Logger
    def format_message severity, timestamp, program, message
      ::Tres::OUTPUT_FORMAT % message + "\n"
    end
  end
end