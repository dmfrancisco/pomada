# encoding: UTF-8

require 'sinatra'
require 'date'
require 'time'
require 'yaml'
require 'mustache/sinatra'


# Some Mustache-Sinatra configs
module Views; end
set :mustache, { :templates => 'views' }


get '/' do
  # Get current data from this day
  data = YAML::load_file "data/state/#{ Date.today.to_s }.yml"

  # Parse tasks from file
  @tasks = parse_tasks(data)

  mustache :hello, {}, :tasks => @tasks
end


post '/save/state' do
  # Save current data for this day
  File.open("data/state/#{ Date.today.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end

  # Save data in separate files for backup
  File.open("data/state/tmp/#{ Time.now.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end
end


post '/save/record' do
  # Save activities done during the day
  File.open("data/records/#{ Date.today.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end
end


PUBLIC_TEMPLATES = ['task']

get '/templates/:template.mustache' do
  # Retrieve partials to render on the client-side
  # For security reasons, whitelist just the few templates needed
  if PUBLIC_TEMPLATES.include? params[:template]
    send_file File.join('.', 'views', "#{ params[:template] }.mustache")
  end
end


helpers do
  # Parse all tasks from data retrieved from yml file.
  # This is necessary because JSON treats arrays differently
  # Instead of [1, 2] we have {'0': 1, '1': 2}
  def parse_tasks(data)
    tasks = {}

    tasks[:today] = []
    data['today'].keys.each do |key|
      tasks[:today] << data['today'][key]
    end

    tasks[:later] = []
    data['later'].keys.each do |key|
      tasks[:later] << data['later'][key]
    end

    return tasks
  end
end
