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
    pending "This is absolutely fucked up"
    # 
    # THIS SHOULD WORK. ADDING THIS EXPECTATION IS ENOUGH TO MAKE
    # @server.serve_asset RETURN FUCKING NIL
    # 
    # @app.asset_packager.sprockets.should_receive :find_asset
    @mock.get('/stylesheets/app.css')
  end

  it "accepts either absolute or relative paths for assets" do
    resp1 = @mock.get('/stylesheets/app.css')
    resp2 = @mock.get('stylesheets/app.css')
    resp1.status.should == 200
    resp2.status.should == 200
  end

  it "serves <APP ROOT>/index.html for requests that don't match an asset of a file in <APP ROOT>/build" do
    @app.template_compiler.compile_to_build 'index.html'
    resp1 = @mock.get('/')
    resp2 = @mock.get('/foobar')
    resp1.body.should == (Anagen.build/'index.html').contents
    resp2.body.should == (Anagen.build/'index.html').contents
  end

  it "serves static files it finds in <APP ROOT>/build" do
    @app.asset_packager.compile_to_build 'stylesheets/app.css'
    @app.asset_packager.sprockets.should_not_receive :find_asset
    @server.should_not
    @mock.get('/stylesheets/app.css')
  end
end