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
      FileUtils.cp FIXTURES/'index.html', SAMPLE_PATH.to_s/'templates/'
    end

    after do
      FileUtils.rm_f SAMPLE_PATH.to_s/'templates'/'index.haml'
    end

    context '#compile_to_build' do
      it "simply copies it over to build/ if the extension is .html" do
        @compiler.compile_to_build 'index.html'
        FileUtils.compare_file(
          SAMPLE_PATH.to_s/'templates'/'index.html',
          SAMPLE_PATH.to_s/'build'/'index.html'
        ).should be_true
      end

      it 'compiles and puts the output in build/index.html' do
        FileUtils.cp FIXTURES/'index.haml', SAMPLE_PATH.to_s/'templates/'
        @compiler.compile_to_build 'index.haml'
        File.read(SAMPLE_PATH.to_s/'build'/'index.html').should ==
          Tilt.new(FIXTURES/'index.haml').render
      end
    end

    context '#compile_to_templates_js' do
      it "adds a template to a global JST object in templates.js" do
        @compiler.compile_to_templates_js 'book.haml'
        templates_js = File.read(SAMPLE_PATH.to_s/'build'/'js'/'templates.js')
        template = @compiler.send(:escape_js, Tilt.new(SAMPLE_PATH.to_s/'templates'/'book.haml').render)
        templates_js.should include template
      end
    end

    it "#compile_all iterates through all templates and compiles each" do
      pending
      @compiler.compile_all
      build = SAMPLE_PATH.to_s/'build'
      templates = SAMPLE_PATH.to_s/'templates'
      File.read(build/'book.html').should == Tilt.new(templates/'book.haml').render
      File.read(build/'books'/'li.html').should == Tilt.new(templates/'books'/'li.haml').render
    end
  end
end