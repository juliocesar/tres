require 'tres/asset_packager'
require 'tres/template_compiler'
require 'listen'

module Tres
  class App
    attr_reader :root, :asset_packager, :listener
    include FileMethods and extend FileMethods
    SKELETON = {
      'index.html'  => '',
      'all.coffee'  => 'assets'/'javascripts',
      '*.js'        => 'assets'/'javascripts',
      '*.scss'      => 'assets'/'stylesheets'
    }    

    def initialize root, fresh = true
      @root = expand(root)
      @logger = Logger.new(STDOUT)
      create_all_dirs if fresh
      make_asset_packager
      make_templates_listener
      copy_templates_over
    end

    def self.open root
      new root, false
    end

    private
    def create_all_dirs
      new_dir @root
      new_dir @root/'assets'
      new_dir @root/'assets'/'stylesheets'
      new_dir @root/'assets'/'javascripts'
      new_dir @root/'templates'
      new_dir @root/'build'
    end

    def copy_templates_over
      SKELETON.each do |file, destination|
        copy Tres.templates_dir/file, @root/destination
      end
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