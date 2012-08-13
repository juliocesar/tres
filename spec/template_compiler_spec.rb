require File.dirname(__FILE__) + '/spec_helper'

describe Tres::TemplateCompiler do
  before do
    FileUtils.rm_rf TMP/'temp'
    @compiler = Tres::TemplateCompiler.new :root => Anagen.root
    clean_build!
  end

  context 'compiling' do
    describe '#compile_to_build' do
      it "with a template not index.*, it simply copies it over to build/<path> if the extension is .html" do
        @compiler.compile_to_build 'books/li.haml'
        (Anagen.build_templates/'books'/'li.html').read.should == (Anagen.templates/'books'/'li.haml').compile
      end

      it "with templates/index.*, compiles to build/index.html" do
        @compiler.compile_to_build 'index.html'
        (Anagen.build/'index.html').read.should == (Anagen.templates/'index.html').read
      end
    end

    context '#compile_to_templates_js' do
      it "adds a template to a global JST object in templates.js" do
        @compiler.compile_to_templates_js 'book.haml'
        Anagen.templates_js.read.should include (Anagen.templates/'book.haml').escaped_compile
      end
    end

    context '#compile_all' do
      it 'compiles index.* to build/' do
        @compiler.stub :compile_to_templates_js => false
        @compiler.compile_all
        (Anagen.build/'index.html').read.should == (Anagen.templates/'index.html').read
      end

      it 'compiles everything else to build/js/templates.js' do
        @compiler.stub :compile_to_build => false
        @compiler.compile_all
        Anagen.templates_js.read.should include (Anagen.templates/'book.haml').escaped_compile
        Anagen.templates_js.read.should include (Anagen.templates/'books'/'li.haml').escaped_compile
      end
    end
  end
end