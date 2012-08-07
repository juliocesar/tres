require 'tilt'

module Tres
  class TemplateCompiler
    include FileMethods
    EXTENSION_MAP = {
      %w(.haml .erb)  => '.html'
    }

    def initialize options = {}
      @root = options[:path]
      @templates = @root.join('templates')
      @build = @root.join('build')
    end

    def compile path
      if extname(path) == '.html'
        copy @templates.join(path).to_s, @build.to_s
      else
        template = Tilt.new @templates.join(path).to_s
        put_in_build with_compiled_extension(template.file), template.render
      end
    end

    private
    def with_compiled_extension file
      ext = extname(file)
      static_ext = EXTENSION_MAP.map { |exts, final| final if exts.include?(ext) }.first
      basename(file, ext) + static_ext
    end

    def put_in_build path, contents
      mkdir_p dirname(path)
      File.open @build.join(path).to_s, 'w' do |file|
        file << contents
      end
    end
  end
end