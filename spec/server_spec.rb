require File.dirname(__FILE__) + '/spec_helper'

describe Tres::Server do
  before do
    stub_listener!
    @app = Tres::App.open Anagen.root
    @server = Tres::Server.new @app
    @mock = Rack::MockRequest.new(@server.to_rack_app)
    clean_build!
  end

  it "serves straight from the app's sprockets environment" do
    @server.should_receive(:serve_asset).and_return(ok_response)
    @server.should_not_receive :serve_index
    @mock.get('/stylesheets/app.css')
  end

  it "accepts either absolute or relative paths for assets" do
    @mock.get('/stylesheets/app.css').status.should == 200
    @mock.get('stylesheets/app.css').status.should == 200
  end

  it "serves <APP ROOT>/index.html for requests that don't match an asset of a file in <APP ROOT>/build" do
    @app.template_manager.compile_to_build 'index.html'
    @server.should_receive(:serve_index).twice.and_return(ok_response)
    @mock.get('/')
    @mock.get('/foobar')
  end

  it "serves static files it finds in <APP ROOT>/build" do
    @app.asset_manager.compile_to_build 'stylesheets/app.css'
    @server.should_not_receive :serve_asset
    @mock.get('/stylesheets/app.css')
  end
end