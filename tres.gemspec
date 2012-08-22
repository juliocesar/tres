# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = 'tres'
  gem.version       = File.read('VERSION')
  gem.authors       = ["Julio Cesar Ody"]
  gem.email         = ["julioody@gmail.com"]
  gem.description   = %q{An ice cold mobile web development framework}
  gem.summary       = %q{An ice cold mobile web development framework}
  gem.homepage      = "http://tres.io"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "listen"
  gem.add_runtime_dependency "tilt"
  gem.add_runtime_dependency "compass"
  gem.add_runtime_dependency "coffee-script"
  gem.add_runtime_dependency "sprockets"
  gem.add_runtime_dependency "json_pure"
  gem.add_runtime_dependency "haml"
  gem.add_runtime_dependency "colorize"
  gem.add_runtime_dependency "ffi"
  gem.add_runtime_dependency "nokogiri"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-nc"
end
