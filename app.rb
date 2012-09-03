# encoding: UTF-8

require 'sinatra'
require 'date'
require 'time'
require 'yaml'


get '/' do
  # Get current data from this day
  data = YAML::load_file "data/state/#{ Date.today.to_s }.yml"

  # Parse tasks from file
  @tasks = parse_tasks(data)

  erb :hello
end

post '/save-state' do
  # Save current data for this day
  File.open("data/state/#{ Date.today.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end

  # Save data in separate files for backup
  File.open("data/state/tmp/#{ Time.now.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
  end
end

post '/save-record' do
  # Save activities done during the day
  File.open("data/records/#{ Date.today.to_s }.yml", 'w') do |f|
    f.puts params.to_yaml
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
