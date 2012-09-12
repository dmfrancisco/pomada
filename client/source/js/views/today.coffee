#
#  Today View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


TodayView = Backbone.View.extend(

  el: $("#today-view")


  # At initialization we bind to the relevant events on the TodayTasks
  # collection, when items are added or changed. Kick things off by
  # loading any existing tasks that might exist
  initialize: ->
    # Bind to relevant events
    app.todayTasks.on "add",   @addOne, this
    app.todayTasks.on "reset", @addAll, this

    # Fetch existing tasks
    app.todayTasks.fetch()


  # Add a single task to the list by creating a view for it,
  # and appending its element to the list
  addOne: (task) ->
    view = new app.TaskView(model: task)
    $("#today-view tbody").append view.render().el # FIXME


  # Add all items in the today tasks collection at once
  addAll: ->
    app.todayTasks.each @addOne

)


# Extend this view with the ManageableView mixin
_.extend(TodayView.prototype, app.Mixins.ManageableView)


app.todayView = new TodayView()
