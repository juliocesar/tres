require '../lib/tres'

run Tres::Server.build(Tres::App.open(Dir.pwd))
