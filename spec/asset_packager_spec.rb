require File.dirname(__FILE__) + '/spec_helper'

describe Tres::AssetPackager do
  before do
    stub_listener!
    @packager = Tres::AssetPackager.new :root => Anagen.root, :logger => MEMLOGGER
  end

  let(:sprockets) { @packager.sprockets }

  it "keeps a sprockets environment in .sprockets" do    
    sprockets.should be_a Sprockets::Environment
  end

  context "opening Anagen" do
    it "has `anagen.js` in js/anagen.js" do
      sprockets['javascripts/anagen.js'].should be_a Sprockets::BundledAsset
    end

    it "has `app.css` in css/app.css" do
      sprockets['stylesheets/app.css'].should be_a Sprockets::BundledAsset
    end
  end

  context "JavaScripts require paths" do
    it "should find anything under <APP ROOT>/assets/javascripts" do
      sprockets['javascripts/all.js'].should be_a Sprockets::BundledAsset
    end
  end

  context "SASS require paths" do
    it "adds Tres' own styles to the path" do
      sprockets['stylesheets/with_imports.scss'].should be_a Sprockets::BundledAsset
    end
  end

  context 'compiling assets to static format' do
    after do
      clean_build!
    end

    it 'compiles stylesheets do the same path found in sprockets' do
      @packager.compile_to_build 'stylesheets/app.css'
      (Anagen.build/'stylesheets'/'app.css').contents.should == sprockets['stylesheets/app.css'].to_s
    end
  end

  context 'creating scripts' do
    after { restore_anagen! }

    it 'creates a new coffeescript if the extension is .coffee' do
      @packager.new_script 'about.coffee'
      File.exists?(Anagen.assets/'javascripts'/'about.coffee').should be_true
    end

    it 'creates a new javascript if the extension is .js' do
      @packager.new_script 'about.js'
      File.exists?(Anagen.assets/'javascripts'/'about.js').should be_true
    end

    it 'creates the directories to a path if necessary' do
      @packager.new_script 'about/index.js'
      File.directory?(Anagen.assets/'javascripts'/'about').should be_true
    end

    it 'raises ScriptExistsError if a script with the same path exists' do
      @packager.new_script 'about/index.js'
      lambda { @packager.new_script 'about/index.js' }.should raise_error(Tres::ScriptExistsError)
    end
  end
end