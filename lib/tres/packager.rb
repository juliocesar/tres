require 'pathname'
require 'sprockets'

module Tres

  class Packager
    def initialize options = {}
      @root = options[:path]
      @logger = options[:logger]
      @sprockets = Sprockets::Environment.new @root do |env|
        env.logger = @logger
      end
    end

    def build_all
    end

    def build_changed modified, added, removed
      @logger.warn "BUILD CHANGED"
    end
  end

end