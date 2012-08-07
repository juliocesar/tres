require 'tilt'

module Tres
  class TemplateCompiler
    include FileMethods

    def initialize options = {}
      @root = options[:path]
      @templates = @root.join('templates')
      @build = @root.join('build')
    end

    def compile path
      if extname(path) == '.html'
        copy @templates.join(path).to_s, @build.to_s
      else
        template = Tilt.new path
        put_in_build template.file, template.render
      end
    end

    private
    def put_in_build path, contents
      mkdir_p dirname(path)
      File.open @build.join(path).to_s, 'w' do |file|
        file << contents
      end
    end
  end
end