#
#  Today Tasks Collection
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


TodayTaskList = Backbone.Collection.extend(

  # Reference to this collection's model
  model: app.Task


  # Reference its location on the server
  url: 'http://localhost:9292/tasks/today'


  # Elements are sorted by their original insertion order
  comparator: (element) ->
    element.get "position"

)


# Create a global collection of tasks for today
app.todayTasks = new TodayTaskList
