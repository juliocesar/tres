require 'tres/asset_packager'
require 'tres/template_compiler'
require 'listen'

module Tres
  class App
    include FileMethods and extend FileMethods
    attr_reader :root, :asset_packager, :listener

    def initialize root, fresh = true
      @root = expand(root)
      @logger = Logger.new(STDOUT)
      create_all_dirs if fresh
      make_asset_packager
      make_templates_listener
    end

    def self.open root
      new root, false
    end

    private
    def create_all_dirs
      new_dir @root
      new_dir @root/'styles'
      new_dir @root/'scripts'
      new_dir @root/'templates'
      new_dir @root/'build'
    end

    def make_asset_packager
      @asset_packager = Tres::AssetPackager.new :assets => @root/'assets', :logger => @logger
    end

    def make_templates_listener
      @listener = Listen.to @root/'templates', :latency => 0.25, :force_polling => true
      @listener.change do |*args| end
      @listener.start false
    end
  end
end