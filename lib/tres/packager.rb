require 'pathname'
require 'sprockets'
require 'compass'
require 'coffee_script'

module Tres

  class Packager
    attr_reader :sprockets

    def initialize options = {}
      @root = options[:path]
      @logger = options[:logger]
      @sprockets = Sprockets::Environment.new @root do |env|
        env.logger = @logger
        env.append_path @root.join('sass')
        env.append_path @root.join('coffeescripts')
      end
    end

    def build_all
    end

    def build_changed modified, added, removed

    end
  end

end