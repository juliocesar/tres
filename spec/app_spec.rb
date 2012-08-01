require File.join(File.dirname(__FILE__), 'spec_helper')

describe Tres::App do
  context '#new' do
    it "creates a folder for the app on" do
      File.directory?(TMP/'temp').should be_true
    end
  end
  
  context "#open" do
    it "opens an existing app" do
      @app.should be_an_instance_of Tres::App
    end    
  end
end