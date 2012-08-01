require 'tres/packager'
require 'listen'

module Tres
  class App
    include FileMethods and extend FileMethods
    attr_reader :path, :packager

    def initialize dir, fresh = true
      @dir = expand(dir)
      @path = Pathname(@dir)
      @logger = Logger.new(STDOUT)
      if fresh
        new_dir dir
        new_dir @path.join('sass').to_s
        new_dir @path.join('coffeescripts').to_s
      end
      @packager = Tres::Packager.new :path => @path, :logger => @logger
      @listener = Listen.to(@path.join('sass').to_s, @path.join('coffeescripts').to_s, :latency => 0.5, :force_polling => true)
      @listener.change do |*args|
        @packager.build_changed *args
      end
      @listener.start false
    end

    def self.open dir
      new dir, false
    end
  end
end