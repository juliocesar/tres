require File.dirname(__FILE__) + '/spec_helper'

describe Tres::TemplateCompiler do
  before do
    FileUtils.rm_rf TMP/'temp'
    @compiler = Tres::TemplateCompiler.new :path => SAMPLE_PATH
  end

  context 'instancing' do
    it 'takes an options hash, and sets @templates to :path + "templates"' do
      @compiler.instance_variable_get(:@templates).should == SAMPLE_PATH.join('templates')
    end
  end

  context 'compiling' do
    before do
      FileUtils.cp FIXTURES/'index.html', TEMPLATES + '/'
    end

    after do
      FileUtils.rm_f TEMPLATES/'index.haml'
    end

    context '#compile_to_build' do
      it "simply copies it over to build/ if the extension is .html" do
        @compiler.compile_to_build 'index.html'
        FileUtils.compare_file(TEMPLATES/'index.html', BUILD/'index.html').should be_true
      end

      it 'compiles and puts the output in build/index.html' do
        FileUtils.cp FIXTURES/'index.haml', TEMPLATES + '/'
        @compiler.compile_to_build 'index.haml'
        File.read(BUILD/'index.html').should == compile(FIXTURES/'index.haml')
      end
    end

    context '#compile_to_templates_js' do
      it "adds a template to a global JST object in templates.js" do
        @compiler.compile_to_templates_js 'book.haml'
        templates_js = File.read(TEMPLATES_JS)
        template = @compiler.send(:escape_js, compile(TEMPLATES/'book.haml'))
        templates_js.should include template
      end
    end

    context '#compile_all' do
      before do
        FileUtils.rm_f Dir.glob(BUILD/'index.html')
        FileUtils.rm_f TEMPLATES_JS
      end

      it 'compiles index.* to build/' do
        FileUtils.cp FIXTURES/'index.haml', TEMPLATES + '/'
        @compiler.compile_all
        File.read(BUILD/'index.html').should == compile(FIXTURES/'index.haml')
      end

      it 'compiles everything else to build/js/templates.js' do
        @compiler.compile_all
        templates_js = File.read(TEMPLATES_JS)
        book = @compiler.send(:escape_js, compile(TEMPLATES/'book.haml'))
        li = @compiler.send(:escape_js, compile(TEMPLATES/'books'/'li.haml'))
        templates_js.should include book
        templates_js.should include li
      end
    end

    it "#compile_all iterates through all templates and compiles each" do
      pending
      @compiler.compile_all
      File.read(BUILD/'book.html').should == compile(TEMPLATES/'book.haml')
      File.read(BUILD/'books'/'li.html').should == compile(TEMPLATES/'books'/'li.haml')
    end
  end
end