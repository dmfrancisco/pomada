# encoding: UTF-8

require 'sinatra'
require 'sinatra/cross_origin'
require 'date'
require 'time'
require 'yaml'
require 'json'


# Enable cross origin requests
configure do
  enable :cross_origin
  set :allow_origin, :any # TODO
end


get '/today/tasks' do
  puts "Fetching today's tasks..."

  # Get current data from this day
  data = YAML::load_file "data/today.yml"

  # Parse tasks retrieved from file and convert them to json
  return parse_tasks(data['today']).to_json
end


get '/activity-inventory/tasks' do
  puts "Fetching activity inventory tasks..."

  # Get current data from the activity inventory
  data = YAML::load_file "data/activity-inventory.yml"

  # Parse tasks retrieved from file and convert them to json
  return parse_tasks(data['activity-inventory']).to_json
end


post '/state' do
  # Save current data for this day
  File.open("data/state/#{ Date.today.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end

  # Save data in separate files for backup
  File.open("data/state/tmp/#{ Time.now.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end
end


post '/record' do
  # Save activities done during the day
  File.open("data/records/#{ Date.today.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end
end


helpers do
  # Parse all tasks from data retrieved from yml file.
  # This is necessary because JSON treats arrays differently
  # Instead of [1, 2] we have { '0': 1, '1': 2 } # FIXME
  def parse_tasks(data)
    tasks = []

    data.keys.each do |key|
      tasks << data[key]
    end

    return tasks
  end
end
