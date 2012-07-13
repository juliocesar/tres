task :package do
  version = File.read('VERSION')
  `mkdir tres-#{version}`
  `cp -r js css tres-#{version}`
  `zip tres-#{version}.zip tres-#{version}`
  `rm -rf tres-#{version}`
end