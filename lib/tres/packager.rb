require 'nokogiri'

module Tres
  class Packager
    include FileMethods

    attr_accessor :root, :asset_manager

    def initialize options = {}
      @root = options[:root]
      @asset_manager = options[:asset_manager]
    end

    def write path
      @asset_manager.compile_to_build path
    end

    def write_all
      index = Nokogiri::HTML(read_file(@root/'build'/'index.html'))
      scripts = index.css('script[src]')
      scripts.each do |script|
        write relativize(script['src'], '.')
      end
      styles = index.css('link[rel="stylesheet"][href]')
      styles.each do |style|
        write relativize(style['href'], '.') rescue nil
      end
    end
  end
end
