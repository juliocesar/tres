require 'tres/packager'
require 'listen'

module Tres
  class App
    include FileMethods and extend FileMethods
    attr_reader :path, :packager
    LISTENER_OPTS = { :latency => 0.25, :force_polling => true }

    def initialize dir, fresh = true
      @dir = expand(dir)
      @path = Pathname(@dir)
      @logger = Logger.new(STDOUT)
      @listeners = {}
      create_all_dirs if fresh
      make_packager
      make_assets_listener
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

    def make_assets_listener
      @listeners[:assets] = Listen.to(@path.join('styles').to_s, @path.join('scripts').to_s, LISTENER_OPTS)
      @listeners[:assets].change do |*args|
        @packager.build_changed *args
      end
      @listeners[:assets].start false
    end

    def make_templates_listener
      @listeners[:templates] = Listen.to(@path.join('templates'), LISTENER_OPTS)
      @listeners[:templates].change do |*args|
      end
      @listeners[:templates].start false
    end
  end
end