require 'pathname'
require 'sprockets'
require 'compass'
require 'coffee_script'

module Tres
  class AssetManager
    attr_reader :sprockets

    include FileMethods

    def initialize options = {}
      @root = options[:root]
      @assets = @root/'assets'
      @logger = options[:logger]
      @sprockets = Sprockets::Environment.new Pathname(@assets) do |env|
        env.logger = @logger
        Compass.sass_engine_options[:load_paths].each do |path|
          env.append_path path.to_s
        end
        env.append_path Tres.styles_dir
        env.append_path Tres.scripts_dir
        env.append_path @assets/'javascripts'
        env.append_path @assets/'stylesheets'
        env.append_path @assets
        env.context_class.class_eval do
          def asset_path path, options = {}; path end
        end
      end
    end

    def compile_to_build path
      asset = @sprockets[path]
      asset.write_to(@root/'build'/path) if asset
    end

    def new_script path, contents = ""
      mkdir_p @assets/'javascripts'/dirname(path)
      path = path + '.coffee' if extname(path).blank?
      raise Tres::ScriptExistsError if file?(@assets/'javascripts'/path)
      create_file @assets/'javascripts'/path, contents
    end

    private
    def coffeescript?
    end
  end
end
