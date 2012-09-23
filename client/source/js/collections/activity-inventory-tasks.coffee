#
#  Activity Inventory Collection
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


ActivityInventoryTaskList = Backbone.Collection.extend(

  # Reference to this collection's model
  model: app.Task


  # Reference its location on the server
  url: 'http://localhost:9292/tasks/activity-inventory'


  # Elements are sorted by their original insertion order
  comparator: (element) ->
    element.get "position"

)


# Create a global collection of tasks from the activity inventory
app.activityInventoryTasks = new ActivityInventoryTaskList
