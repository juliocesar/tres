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
      unless file?(Tres.templates_path/'templates.js')
        copy Tres.templates_path/'templates.js', @build.join('js').to_s 
      end
      File.open @build.join('js').to_s/'templates.js', 'a+' do |file|
        file << jst_format(path, template.render)
      end
    end

    def compile_all
      if index = first_index_file
        compile_to_build index 
      end
      Find.find(@templates.to_s) do |path|
        next if dir?(path) or path =~ /index/
        compile_to_templates_js Pathname(path).relative_path_from(@templates).to_s
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

    def jst_format path, template
      "JST[\"#{path.sub(extname(path), '')}\"] = \"#{escape_js(template)}\";"
    end

    def escape_js js
      js.
        gsub('\\', '\\\\\\').
        gsub(/\r\n|\r|\n/, '\\n').
        gsub(/['"]/, '\\\\\&').
        gsub('</script>','</scr"+"ipt>')
    end

    def first_index_file
      Dir.glob(@templates.to_s + '/index.*').first
    end
  end
end