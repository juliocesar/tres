require 'tres/asset_packager'
require 'tres/template_compiler'
require 'listen'
require 'ostruct'

module Tres
  class App
    attr_reader :root, :asset_packager, :template_compiler, :listeners
    include FileMethods and extend FileMethods
    SKELETON = {
      'config.ru'     => '',
      'index.html'    => 'templates',
      'home.haml'     => 'templates',
      'all.coffee'    => 'assets'/'javascripts',
      'app.coffee'    => 'assets'/'javascripts',
      'home.coffee'   => 'assets'/'javascripts'/'screens',
      'all.scss'      => 'assets'/'stylesheets'
    }    

    def initialize root, fresh = true
      @root = expand(root)
      @logger = Tres::Logger.new(STDOUT)
      @listeners = OpenStruct.new
      if fresh
        create_all_dirs
        copy_templates_over
      end
      make_asset_packager
      make_template_compiler
      make_templates_listener
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
      new_dir @root/'assets'/'javascripts'/'screens'
      new_dir @root/'templates'
      new_dir @root/'build'
    end

    def copy_templates_over
      SKELETON.each do |file, destination|
        copy Tres.templates_dir/file, @root/destination
      end
    end

    def make_asset_packager
      @asset_packager = Tres::AssetPackager.new :root => @root, :logger => @logger
    end

    def make_template_compiler
      @template_compiler = Tres::TemplateCompiler.new :root => @root
    end

    def make_templates_listener
      @listeners.templates = Listen.to @root/'templates', :latency => 0.25, :force_polling => true
      @listeners.templates.change do |*args| end
      @listeners.templates.start false
    end
  end
end