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
  url: 'http://localhost:9292/activity-inventory/tasks'


  # Todos are sorted by their original insertion order.
  comparator: (task) ->
    task.get('order')

)


# Extend this collection with the OrderedCollection mixin
_.extend(ActivityInventoryTaskList.prototype, app.Mixins.OrderedCollection)


# Create a global collection of tasks from the activity inventory
app.activityInventoryTasks = new ActivityInventoryTaskList
