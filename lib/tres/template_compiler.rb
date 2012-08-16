require 'tilt'
require 'haml'
require 'find'
require 'stringio'

module Tres
  class TemplateCompiler
    include FileMethods

    EXTENSION_MAP = {
      %w(.haml .erb)  => '.html'
    }

    def initialize options = {}
      @root = options[:root]
      @templates = @root/'templates'
      @build = @root/'build'
    end

    def compile_to_build path
      return copy(@templates/path, @build/path) if path == 'index.html'
      mkdir_p @build/'templates'/dirname(path)
      if static? path
        copy @templates/path, @build/'templates'/path
      else
        template = Tilt.new @templates/path
        destination = compiled_extension(@build/'templates'/path)
        create_file destination, template.render
      end
    end

    def compile_to_templates_js path
      if static? path
        contents = read_file(@templates/path)
      else
        contents = Tilt.new(@templates/path).render
      end
      mkdir_p @build/'js'
      unless file?(@build/'js'/'templates.js')
        copy Tres.templates_dir/'templates.js', @build/'js'
      end
      append_to_file @build/'js'/'/templates.js', jst_format(path, contents)
    end

    def compile_all
      if index = first_index_file
        compile_to_build index 
      end
      Find.find(@templates) do |path|
        next if dir?(path) or path =~ /index/
        compile_to_templates_js Pathname(path).relative_path_from(Pathname(@templates)).to_s
      end
    end

    private
    def compiled_extension path
      actual = extname(path)
      wanted = EXTENSION_MAP.map { |exts, final| final if exts.include?(actual) }.first
      dirname(path)/(basename(path, actual) + wanted)
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

    def static? path
      extname(path) == '.html'
    end

    def first_index_file
      file = Dir.glob(@templates/'index.*').first
      if file
        Pathname(file).relative_path_from(Pathname(@templates)).to_s
      end
    end
  end
end