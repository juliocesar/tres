describe Tres::Packager do
  before do
    FileUtils.rm_rf TMP/'temp'
    stub_listener!
    @packager = Tres::Packager.new :path => SAMPLE_APP, :logger => MEMLOGGER
  end

  context "when using sprockets" do
    let(:sprockets) { @packager.sprockets }

    it "keeps a sprockets environment in .sprockets" do    
      sprockets.should be_a Sprockets::Environment
    end

    context "opening the sample app" do
      it "has `app.coffee` among it's assets" do
        sprockets['js/app.coffee'].should be_a Sprockets::BundledAsset
      end

      it "has `app.scss` among it's assets" do
        sprockets['css/app.scss'].should be_a Sprockets::BundledAsset
      end
    end

    context "SASS require paths" do
      it "adds Tres' own styles to the path" do
        lambda do
          sprockets['with_imports.scss']
        end.should_not raise_error
      end
    end
  end
end