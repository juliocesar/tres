require 'sinatra'



guard 'coffeescript', :output => 'js' do
  watch('coffee/(.*)\.coffee')
end

guard 'compass' do
  watch('^scss/(.*)\.s[ac]ss')
  watch('^scss/themes/(.*)\.s[ac]ss')
end

# Anagen stuff
guard 'coffeescript', :output => 'anagen' do
  watch('anagen/(.*)\.coffee')
end

guard 'compass' do
  watch('^anagen/(.*)\.s[ac]ss')
end

guard 'coffeescript', :input => 'app/assets/javascripts'

guard 'compass' do
  watch('^src/(.*)\.s[ac]ss')
end

guard 'sass', :input => 'sass', :output => 'css'
