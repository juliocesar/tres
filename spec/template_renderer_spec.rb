describe Tres::TemplateRenderer do
  context 'instancing' do
    before do
      FileUtils.rm_rf TMP/'temp'
      stub_listener!
      @renderer = Tres::TemplateRenderer.new :path => SAMPLE_APP
    end

    it 'takes an options hash, and sets @root to :path + "templates"' do
      @renderer.instance_variable_get(:@root).should == SAMPLE_APP.join('templates')
    end
  end
  it 'it renders Haml, ERB, among others'

  context 'compiling to HTML' do
    it 'index.* gets compiled into build/index.html'
    it 'anything else gets injected in build/js/templates.js'
  end
end