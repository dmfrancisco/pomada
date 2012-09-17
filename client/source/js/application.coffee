#
#  Main CoffeeScript file
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#
#= require libs/jquery.multisortable
#= require libs/underscore.min
#= require libs/backbone.min
#= require libs/backbone.getters.setters
#
#= require_directory ./utils
#= require_directory ./models
#= require_directory ./collections
#= require_directory ./views
#= require manager
#= require router
#


# Connect the Today and Activity Inventory lists in order to drag-and-drop tasks between both
app.todayView.trigger "connect", app.activityInventoryView
app.activityInventoryView.trigger "connect", app.todayView
