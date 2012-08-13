require 'pathname'
require 'sprockets'
require 'compass'
require 'coffee_script'

module Tres
  class AssetPackager
    attr_reader :sprockets

    def initialize options = {}
      @root   = options[:assets]
      @logger = options[:logger]
      @sprockets = Sprockets::Environment.new @root do |env|
        env.logger = @logger
        Compass.sass_engine_options[:load_paths].each do |path|
          env.append_path path.to_s
        end
        env.append_path Tres.styles_dir
        env.append_path Tres.scripts_dir
        env.append_path @root
      end
    end

    def package_styles modified, added, removed
    end

    def package_scripts modified, added, removed
    end
  end
end