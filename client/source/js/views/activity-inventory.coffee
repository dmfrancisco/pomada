#
#  Activity Inventory Tasks View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


ActivityInventoryView = Backbone.SortableListView.extend(

  # Instead of generating a new element, bind to the existing skeleton of
  # the App already present in the HTML.
  el: $("#activity-inventory-view")
  $sortable: $("#activity-inventory-view .tasks tbody")


  # Delegated events for creating new items, and clearing completed ones
  events:
    "submit #new-task": "createTask"


  initialize: (options) ->
    # Call parent's constructor
    @constructor.__super__.initialize.apply this, [options]

    # Bind to relevant events
    @collection.on "add",   @addOne, this
    @collection.on "reset", @addAll, this
    @collection.on "add reset", @refreshSortable, this

    # Fetch existing tasks
    @collection.fetch()

    # Cache jQuery DOM elements
    @$form = @$el.find("form")


  # Add a single task to the list by creating a view for it,
  # and appending its element to the list
  addOne: (task) ->
    view = new app.TaskView(model: task)
    $("#activity-inventory-view tbody").append view.render().el


  # Add all items in the today tasks collection at once
  addAll: ->
    @collection.each @addOne


  # If you hit return in the main input field, create a new task
  createTask: (e) ->
    e.preventDefault()

    $nameInput = @$form.find("input[name='name']")
    $projectInput = @$form.find("input[name='project']")

    # A task must have a name
    return unless $nameInput.val()

    @collection.create {
      name:    $nameInput.val()
      project: $projectInput.val()
    }
    $nameInput.val ""
    $projectInput.val ""

)


# Extend this view with the ManageableView mixin
_.extend(ActivityInventoryView.prototype, app.Mixins.ManageableView)


app.activityInventoryView = new ActivityInventoryView({ collection : app.activityInventoryTasks })
