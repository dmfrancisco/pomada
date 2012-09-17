#
#  Today View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


TodayView = Backbone.SortableListView.extend(

  el: $("#today-view")
  $sortable: $("#today-view .tasks tbody")


  # At initialization we bind to the relevant events on the TodayTasks
  # collection, when items are added or changed. Kick things off by
  # loading any existing tasks that might exist
  initialize: (options) ->
    # Call parent's constructor
    @constructor.__super__.initialize.apply this, [options]

    # Bind to relevant events
    @collection.on "add",   @addOne, this
    @collection.on "reset", @addAll, this
    @collection.on "add reset", @refreshSortable, this

    # Fetch existing tasks
    @collection.fetch()


  # Add a single task to the list by creating a view for it,
  # and appending its element to the list
  addOne: (task) ->
    taskView = new app.TaskView(model: task)
    $("#today-view tbody").append taskView.render().el


  # Add all items in the today tasks collection at once
  addAll: ->
    app.todayTasks.each @addOne

)


# Extend this view with the ManageableView mixin
_.extend(TodayView.prototype, app.Mixins.ManageableView)


app.todayView = new TodayView({ collection : app.todayTasks })
