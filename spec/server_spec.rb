require File.dirname(__FILE__) + '/spec_helper'

describe Tres::Server do
  before do
    stub_listener!
    @app = Tres::App.open Anagen.root
    @server = Rack::MockRequest.new(Tres::Server.build(@app))
  end

  context 'serving assets' do
    it "always serves straight from the app's sprockets environment" do
      @app.asset_packager.sprockets.should_receive(:find_asset)
      @server.get('/stylesheets/app.css')
    end
    it "accepts either absolute or relative paths for assets" do
      resp1 = @server.get('/stylesheets/app.css')
      resp2 = @server.get('stylesheets/app.css')
      resp1.status.should == 200
      resp2.status.should == 200
    end
  end

  it 'serves <APP ROOT>/index.html for every other page request' do
    @app.template_compiler.compile_to_build 'index.html'
    resp1 = @server.get('/')
    resp2 = @server.get('/foobar')
    resp1.body.should == (Anagen.build/'index.html').contents
    resp2.body.should == (Anagen.build/'index.html').contents
  end
end