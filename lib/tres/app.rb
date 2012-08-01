require 'tres/packager'

module Tres
  class App
    include FileMethods and extend FileMethods
    attr_reader :path, :packager

    def initialize dir, fresh = true
      @path = expand dir
      new_dir dir if fresh
      @packager = Tres::Packager.new dir
    end

    def self.open dir
      new dir, false
    end
  end
end