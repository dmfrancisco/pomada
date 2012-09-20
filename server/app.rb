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
  set :allow_methods, [:get, :post, :put]

  # Allow cookies to be sent with the requests
  # set :allow_credentials, true
end







end


#
#  ROUTES
#

# Before all gets, posts, and puts for tasks, check if the :list argument is valid
before '/tasks/:list*' do
  status 404 unless ['today', 'activity-inventory'].include? params[:list]
end


# Fetching today's or activity inventory tasks
get '/tasks/:list' do
  load_tasks(params[:list]).to_json
end


# Saving a new task
post '/tasks/:list' do
  new_task = JSON.parse request.body.read.to_s
  save_new_task(params[:list], new_task).to_json # Return task with new ID
end


# Editing a task
put '/tasks/:list/:id' do
  edited_task = JSON.parse request.body.read.to_s
  save_task(params[:list], edited_task).to_json
end


post '/record' do
  # Save activities done during the day
  # File.open("data/record/#{ Date.today.to_s }.yml", 'w') do |f|
  #   f.puts params.to_yaml
  # end
end


options '*' do
  # Support HTTP OPTIONS request for cross-origin resource sharing
  response['Access-Control-Allow-Headers'] = 'Content-Type'
end


#
#  HELPERS
#

helpers do
  def load_tasks(listname)
    # TaskList.get(listname).tasks
    YAML.load_file("data/#{ listname }.yml")
  end


  def save_tasks(listname, tasks)
    File.open("data/#{ listname }.yml", 'w') do |out|
      YAML.dump tasks, out
    end

    # Save data also in a separate file for backup
    File.open("data/backup/#{ listname }_#{ friendly_time }.yml", 'w') do |out|
      YAML.dump tasks, out
    end
  end


  def save_new_task(listname, new_task)
    tasks = load_tasks(listname)

    new_task['id'] = tasks.length # Set its unique ID
    tasks << new_task # Append the new data

    save_tasks(listname, tasks)
    return new_task
  end


  def save_task(listname, edited_task)
    tasks = load_tasks(listname)

    task = tasks.find { |task| task['id'] == edited_task['id'] }
    task.merge! edited_task

    save_tasks(listname, tasks)
    return task
  end


  # Human readable time string
  def friendly_time(time = DateTime.now)
    time.strftime("%Y-%m-%d_%I:%M%p")
  end
end
