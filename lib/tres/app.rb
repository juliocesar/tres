module Tres
  class App
    include FileMethods and extend FileMethods
    attr_reader :path, :name

    def initialize dir, fresh = true
      @path = expand dir
      new_dir dir if fresh
      @name = "Tres App"
    end


    def self.open dir
      new dir, false
    end
  end
end