require File.join(File.dirname(__FILE__), 'spec_helper')

describe Tres::App do
  context 'creating a new app' do
    it "creates a folder for the app on" do
      File.directory?(TMP/'temp').should be_true
    end

    it "creates a sass folder in the app's folder" do
      File.directory?(TMP/'temp'/'sass').should be_true
    end

    it "creates a coffeescripts folder in the app's folder" do
      File.directory?(TMP/'temp'/'coffeescripts').should be_true
    end

    it "creates a packager for the app" do
      @app.packager.should be_an_instance_of Tres::Packager
    end
  end  
end