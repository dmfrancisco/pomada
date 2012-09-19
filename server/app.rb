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

  # Comma separate list of remote hosts that are allowed
  set :allow_origin, :any

  # HTTP methods allowed
  # set :allow_methods, [:get, :post]

  # Allow cookies to be sent with the requests
  # set :allow_credentials, true
end


# Fetching today's tasks
get '/today/tasks' do
  data = YAML::load_file("data/today.yml").to_json
end


# Saving tasks for today
post '/today/tasks' do
  data = YAML::load_file "data/today.yml"

  # Append the new data
  data << JSON.parse request.body.read.to_s
  data = data.to_yaml

  File.open("data/today.yml", 'w') do |f|
    f.puts data
  end

  # Save data also in a separate file for backup
  File.open("data/backup/today_#{ friendly_time }.yml", 'w') do |f|
    f.puts data
  end
end


# Fetching activity inventory tasks
get '/activity-inventory/tasks' do
  YAML::load_file("data/activity-inventory.yml").to_json
end


# Saving tasks in the activity inventory
post '/activity-inventory/tasks' do
  data = YAML::load_file "data/activity-inventory.yml"

  # Append the new data
  data << JSON.parse request.body.read.to_s
  data = data.to_yaml

  File.open("data/activity-inventory.yml", 'w') do |f|
    f.puts data
  end

  # Save data also in a separate file for backup
  File.open("data/backup/activity-inventory_#{ friendly_time }.yml", 'w') do |f|
    f.puts data
  end
end


post '/record' do
  # Save activities done during the day
  # File.open("data/record/#{ Date.today.to_s }.yml", 'w') do |f|
  #   f.puts params.to_yaml
  # end
end


options '*' do
  # Important to support HTTP OPTIONS request for cross-origin resource sharing
  response['Access-Control-Allow-Headers'] = 'Content-Type'
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

  # Human readable time string
  def friendly_time(time = DateTime.now)
    time.strftime("%Y-%m-%d_%I:%M%p")
  end
end
