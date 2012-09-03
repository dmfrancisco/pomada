require 'bundler'
Bundler.setup :default
require 'sinatra/base'
require 'sprockets'
require 'less'
require './app'

# Add all subdirectories inside the less folder to the Less compiler
Dir.glob(File.join('.', 'source', 'less', "**/")).each do |dir|
  Less.paths << File.expand_path(dir)
end

# The route where all assets will live
map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'source/coffee'
  environment.append_path 'source/less'
  run environment
end

# Root of the sinatra application
map '/' do
  run Sinatra::Application
end
