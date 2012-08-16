require File.dirname(__FILE__) + '/spec_helper'

describe Tres::AssetPackager do
  before do
    stub_listener!
    @packager = Tres::AssetPackager.new :assets => Anagen.root/'assets', :logger => MEMLOGGER
  end

  context "when using sprockets" do
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

    context "SASS require paths" do
      it "adds Tres' own styles to the path" do
        lambda do
          sprockets['/stylesheets/with_imports.scss']
        end.should_not raise_error
      end
    end
  end
end