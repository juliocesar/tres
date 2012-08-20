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
      @assets = @root/'assets'
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
      contents = static?(path) ? read_file(@templates/path) : Tilt.new(@templates/path).render
      unless file?(@assets/'javascripts'/'templates.js')
        copy Tres.templates_dir/'templates.js', @assets/'javascripts'
      end
      unless in_templates_js? path
        append_to_file @assets/'javascripts'/'templates.js', jst_format(path, contents)
      end
    end

    def new_template path, contents = ""
      mkdir_p @templates/dirname(path)
      raise Tres::TemplateExistsError if file?(@templates/path)
      create_file @templates/path, contents
    end

    def compile_all
      if index = first_index_file
        compile_to_build index 
      end
      Find.find(@templates) do |path|
        next if dir?(path) or path =~ /index/
        compile_to_templates_js relativize(path, @templates)
      end
    end

    def remove_template path
      if path.is_a? Array
        path.each do |file|
          remove_template file
        end
      end
      return false if path =~ /index/
      remove_from_templates_js path
      delete! @templates/path
      delete! @build/path
    end

    private
    def in_templates_js? path
      lines = readlines @assets/'javascripts'/'templates.js'
      !!lines.index { |line| line =~ /^JST\[\"#{path.sub(extname(path), '')}\"\]/ }
    end

    def remove_from_templates_js path
      return false unless file?(@assets/'javascripts'/'templates.js')
      lines = readlines @assets/'javascripts'/'templates.js'
      lines.reject! { |line| line =~ /^JST\[\"#{path.sub(extname(path), '')}\"\]/ }
      create_file @assets/'javascripts'/'templates.js', lines.join("\n")
    end

    def compiled_extension path
      actual = extname(path)
      wanted = EXTENSION_MAP.map { |exts, final| final if exts.include?(actual) }.first
      dirname(path)/(basename(path, actual) + wanted)
    end

    def jst_format path, template
      "JST[\"#{path.sub(extname(path), '')}\"] = \"#{escape_js(template)}\";\n"
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
      relativize(file, @templates) if file
    end
  end
end