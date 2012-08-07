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

  it 'it renders Haml, ERB, among others'

  context 'compiling to HTML' do
    context 'build/index.*' do
      before do
        FileUtils.cp FIXTURES/'index.html', SAMPLE_PATH.to_s/'templates/'
      end

      after do
        FileUtils.rm_f SAMPLE_PATH.to_s/'build'/'index.html'
      end

      it "simply copies it over to build/ if the extension is .html" do
        @compiler.compile 'index.html'
        puts "TEMPLATES: " + File.read(SAMPLE_PATH.to_s/'templates'/'index.html')
        puts "BUILD: " + File.read(SAMPLE_PATH.to_s/'build'/'index.html')

        FileUtils.compare_file(
          SAMPLE_PATH.to_s/'templates'/'index.html',
          SAMPLE_PATH.to_s/'build'/'index.html'
        ).should be_true
      end
      it 'compiles and copies the output to build/index.html' 
    end
    it 'anything else gets injected in build/js/templates.js'
  end
end