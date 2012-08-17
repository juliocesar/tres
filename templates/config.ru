require '../lib/tres'

run Tres::Server.new(Tres::App.open(Dir.pwd)).to_rack_app
