require 'tilt'
require 'find'
require 'stringio'

module Tres
  class TemplateCompiler
    include FileMethods
    EXTENSION_MAP = {
      %w(.haml .erb)  => '.html'
    }

    def initialize options = {}
      @root = options[:path]
      @build = @root.join('build')
      @templates = @root.join('templates')
    end

    def compile_to_build path
      if extname(path) == '.html'
        copy @templates.join(path).to_s, @build.to_s
      else
        template = Tilt.new @templates.join(path).to_s
        put_in_build with_compiled_extension(template.file), template.render
      end
    end

    def compile_to_templates_js path
      template = Tilt.new @templates.join(path).to_s
      mkdir_p @build.join('js').to_s
      copy Tres.templates_path/'templates.js', @build.join('js').to_s
      File.open @build.join('js').to_s/'templates.js', 'a' do |file|
        file << jst_format(path, template.render)
      end
    end

    def compile_all      
      extensions = EXTENSION_MAP.keys.flatten.uniq
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

    def jst_format path, template
      "JST[\"#{basename(path, extname(path))}\"] = \"#{escape_js(template)}\";"
    end

    def escape_js js
      # https://github.com/itkin/respond_to_parent/blob/master/lib/responds_to_parent.rb
      js.
        gsub('\\', '\\\\\\').
        gsub(/\r\n|\r|\n/, '\\n').
        gsub(/['"]/, '\\\\\&').
        gsub('</script>','</scr"+"ipt>')
    end
  end
end