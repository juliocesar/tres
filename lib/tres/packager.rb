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
        Compass.sass_engine_options[:load_paths].each do |path|
          env.append_path path.to_s
        end
        env.append_path Tres.styles_path
        env.append_path Tres.scripts_path
        env.append_path @root.join('styles')
        env.append_path @root.join('scripts')
      end
    end

    def build_all
    end

    def build_changed modified, added, removed

    end
  end
end