require File.join(File.dirname(__FILE__), 'spec_helper')

describe Tres::App do
  before do
    FileUtils.rm_rf TMP/'temp'
    stub_listener!
    @app = Tres::App.new TMP/'temp'
  end

  context 'creating a new app' do
    it "creates a folder for the app on" do
      File.directory?(TMP/'temp').should be_true
    end

    it "creates a sass folder in the app's folder" do
      File.directory?(TMP/'temp'/'styles').should be_true
    end

    it "creates a coffeescripts folder in the app's folder" do
      File.directory?(TMP/'temp'/'scripts').should be_true
    end

    it "creates a packager for the app" do
      @app.packager.should be_an_instance_of Tres::Packager
    end
  end  

  context 'listeners' do
    it "keeps listeners in a hash" do
      @app.instance_variable_get(:@listeners).should be_a Hash
    end
  end
end