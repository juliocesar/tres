require 'tres/asset_manager'
require 'tres/template_manager'
require 'listen'
require 'ostruct'

module Tres
  class App
    attr_reader :root, :asset_manager, :template_manager, :packager, :listeners

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

    def initialize root, options = { :fresh => true }
      @root = expand(root)
      @logger = Tres::Logger.new(STDOUT)
      @listeners = OpenStruct.new
      if options[:fresh] == true
        create_all_dirs
        copy_templates_over
        copy_fonts_over
      end
      make_asset_manager
      make_template_manager
      make_packager
      make_templates_listener unless options[:deaf] == true
    end

    def self.open root, options = {}
      new root, options.merge(:fresh => false)
    end

    private
    def create_all_dirs
      new_dir @root
      new_dir @root/'assets'
      new_dir @root/'assets'/'stylesheets'
      new_dir @root/'assets'/'javascripts'
      new_dir @root/'assets'/'javascripts'/'screens'
      new_dir @root/'assets'/'javascripts'/'models'
      new_dir @root/'assets'/'javascripts'/'collections'
      new_dir @root/'templates'
      new_dir @root/'build'
    end

    def copy_templates_over
      SKELETON.each do |file, destination|
        copy Tres.templates_dir/file, @root/destination
      end
    end

    def copy_fonts_over
      copy Tres.root/'font', @root/'build'
    end

    def make_asset_manager
      @asset_manager = Tres::AssetManager.new :root => @root, :logger => @logger
    end

    def make_template_manager
      @template_manager = Tres::TemplateManager.new :root => @root
    end

    def make_packager
      @packager = Tres::Packager.new :root => @root, :asset_manager => @asset_manager
    end

    def make_templates_listener
      @listeners.templates = Listen.to @root/'templates', :latency => 0.25, :force_polling => true
      @listeners.templates.change do |modified, added, removed|
        added_modified  = (added + modified).map { |path| relativize(path, @root) }
        removed         = removed.map { |path| relativize(path, @root) }

        unless added_modified.empty?
          begin
            Tres.say_progress "Compiling #{added_modified.join(', ').colorize(:yellow)}" do
              @template_manager.compile_all
            end
          rescue Exception => e
            Tres.say "Error: #{e.message}"
          end
        end

        unless removed.empty?
          Tres.say_progress "Removing #{removed.join(', ').colorize(:yellow)}" do
            @template_manager.remove_template removed
          end
        end
      end
      @listeners.templates.start false
    end
  end
end
