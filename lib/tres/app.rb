require 'tres/packager'
require 'listen'

module Tres
  class App
    include FileMethods and extend FileMethods
    attr_reader :path, :packager
    LISTENER_OPTS = { :latency => 0.25, :force_polling => true }

    def initialize dir, fresh = true
      @dir = expand(dir) and @path = Pathname(@dir)
      @logger = Logger.new(STDOUT)
      @listeners = {}
      create_all_dirs if fresh
      make_packager
      make_styles_listener
      make_scripts_listener
      make_templates_listener
    end

    def self.open dir
      new dir, false
    end

    private
    def create_all_dirs
      new_dir @dir
      new_dir @path.join('styles').to_s
      new_dir @path.join('scripts').to_s
      new_dir @path.join('templates').to_s
    end

    def make_packager
      @packager = Tres::Packager.new :path => @path, :logger => @logger
    end

    def make_styles_listener
      @logger.warn "No styles dir found. Skipping..." and return unless dir?(@path.join('styles').to_s)
      @listeners[:styles] = Listen.to(@path.join('styles'), LISTENER_OPTS)
      @listeners[:styles].change do |*args| @packager.package_styles(*args) end
      @listeners[:styles].start false
    end

    def make_scripts_listener
      @logger.warn "No scripts dir found. Skipping..." and return unless dir?(@path.join('scripts').to_s)
      @listeners[:scripts] = Listen.to(@path.join('scripts').to_s, LISTENER_OPTS)
      @listeners[:scripts].change do |*args| @packager.package_scripts *args end
      @listeners[:scripts].start false
    end

    def make_templates_listener
      @listeners[:templates] = Listen.to(@path.join('templates'), LISTENER_OPTS)
      @listeners[:templates].change do |*args| end
      @listeners[:templates].start false
    end
  end
end