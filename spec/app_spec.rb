require File.dirname(__FILE__) + '/spec_helper'

describe Tres::App do
  before do
    FileUtils.rm_rf TMP/'temp'
    @app = Tres::App.new TMP/'temp'
  end

  it 'opens an existing app with Tres::All.open' do
    stub_listener!
    an_app = Tres::App.open TMP/'temp'
    an_app.should be_a Tres::App
  end

  context 'creating a new app' do
    before { stub_listener! }

    it "creates a folder for the app on" do
      File.directory?(TMP/'temp').should be_true
    end

    it "creates a assets folder with scripts and styles in it" do
      File.directory?(TMP/'temp'/'assets').should be_true
      File.directory?(TMP/'temp'/'assets'/'stylesheets').should be_true
      File.directory?(TMP/'temp'/'assets'/'javascripts').should be_true
    end

    it "creates a build folder in the app's folder" do
      File.directory?(TMP/'temp'/'build').should be_true
    end

    it "creates an asset packager" do
      @app.asset_manager.should be_a Tres::AssetManager
    end

    it "creates a template compiler" do
      @app.template_manager.should be_a Tres::TemplateManager
    end

    it "creates a listener for templates" do
      @app.listeners.templates.should_not be_nil # yeah, sorta
    end
  end
end