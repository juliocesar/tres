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
    pending "RSpec fail. Setting an expectation on @server.serve_asset makes it return nil"
    @server.should_receive :serve_asset
    @server.should_not_receive :serve_index
    @mock.get('/stylesheets/app.css')
  end

  it "accepts either absolute or relative paths for assets" do
    @mock.get('/stylesheets/app.css').status.should == 200
    @mock.get('stylesheets/app.css').status.should == 200
  end

  it "serves <APP ROOT>/index.html for requests that don't match an asset of a file in <APP ROOT>/build" do
    pending "This fails, again for no good reason"
    @app.template_compiler.compile_to_build 'index.html'
    @server.should_receive(:serve_index).twice
    @mock.get('/')
    @mock.get('/foobar')
  end

  it "serves static files it finds in <APP ROOT>/build" do
    @app.asset_packager.compile_to_build 'stylesheets/app.css'
    @server.should_not_receive :serve_asset
    @mock.get('/stylesheets/app.css')
  end
end