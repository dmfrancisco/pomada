# encoding: UTF-8

require 'sinatra'
require 'sinatra/cross_origin'
require 'date'
require 'time'
require 'json'
require 'data_mapper'


#  Configurations
#

# Setup the sqlite database
DataMapper.setup(:default, "sqlite3://#{ Dir.pwd }/dev.db")

# Enable cross origin requests
configure do
  enable :cross_origin

  # Comma separate list of remote hosts that are allowed
  set :allow_origin, :any

  # HTTP methods allowed
  set :allow_methods, [:get, :post, :put, :delete]

  # Allow cookies to be sent with the requests
  # set :allow_credentials, true
end


#  Models
#

class TaskList
  include DataMapper::Resource

  property :name, String, :key => true

  has n, :tasks
end

class Task
  include DataMapper::Resource

  property :id,        Serial # An auto-increment integer key
  property :state,     String
  property :name,      String
  property :project,   String
  property :pomodoros, Integer
  property :estimate,  Integer # Estimated pomodoros needed to accomplish this task
  property :interrups, Integer
  property :position,  Integer
  property :completed_at, DateTime

  belongs_to :task_list
end

# Make the schema match the model
DataMapper.auto_upgrade!

# Seed data
TaskList.first_or_create(:name => "today")
TaskList.first_or_create(:name => "activity-inventory")


#  Routes
#

# Before all gets, posts, and puts for tasks, check if the :list argument is valid
before '/tasks/:list*' do
  status 404 unless ['today', 'activity-inventory'].include? params[:list]
end

# Fetching today's or activity inventory tasks
get '/tasks/:list' do
  TaskList.get(params[:list]).tasks.to_json
end

# Saving a new task
post '/tasks/:list' do
  new_task = JSON.parse(request.body.read.to_s)

  task = Task.new new_task
  task.task_list = TaskList.get(params[:list])
  task.position  = TaskList.get(params[:list]).tasks.count
  task.save()

  return task.to_json # Return task with new ID
end

# Editing a task
put '/tasks/:list/:id' do
  edited_task = JSON.parse(request.body.read.to_s)
  edited_task[:task_list_name] = params[:list]

  task = Task.get(edited_task['id'])
  task.update(edited_task)
end

# Deleting a task
delete '/tasks/:list/:id' do
  Task.get(params['id']).destroy
end

post '/record' do
  # Save activities done during the day
end

options '*' do
  # Support HTTP OPTIONS request for cross-origin resource sharing
  response['Access-Control-Allow-Headers'] = 'Content-Type'
end
