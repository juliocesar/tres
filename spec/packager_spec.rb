require File.dirname(__FILE__) + '/spec_helper'

describe Tres::Packager do
  before do
    @packager = Tres::Packager.new :root => Anagen.root, 
      :asset_manager => Tres::AssetManager.new(:root => Anagen.root, :logger => MEMLOGGER)
  end

  after   { clean_build! }

  it 'writes an asset existent in #asset_manager to <root>/build' do
    @packager.write 'javascripts/anagen.js'
    File.exists?(Anagen.build/'javascripts'/'anagen.js').should be_true
  end

  it 'writes all locally referenced stylesheets and JavaScripts to <root>/build' do
    Tres::FileMethods.mkdir_p Anagen.build
    Tres::FileMethods.copy Anagen.templates/'index.html', Anagen.build
    @packager.asset_manager.should_receive(:compile_to_build).with('javascripts/all.js')
    @packager.write_all
    # File.exists?(Anagen.build/'javascripts'/'all.js').should be_true
    # File.exists?(Anagen.build/'stylesheets'/'all.css').should be_true
  end
end
