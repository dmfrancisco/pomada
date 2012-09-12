#
#  Activity Inventory Tasks View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


ActivityInventoryView = Backbone.View.extend(

  # Instead of generating a new element, bind to the existing skeleton of
  # the App already present in the HTML.
  el: $("#activity-inventory-view")


  # Delegated events for creating new items, and clearing completed ones.
  events:
    "submit #new-task": "createTask"
  #   "click #clear-completed": "clearCompleted"
  #   "click #toggle-all":      "toggleAllComplete"


  initialize: ->
    # Bind to relevant events
    app.activityInventoryTasks.on "add",   @addOne, this
    app.activityInventoryTasks.on "reset", @addAll, this

    # Fetch existing tasks
    app.activityInventoryTasks.fetch()

    # Cache jQuery DOM elements
    @$form = @$el.find("form")

    # @allCheckbox = @$("#toggle-all")[0]
    # Tasks.on "add",   @addOne, this
    # Tasks.on "reset", @addAll, this
    # Tasks.on "all",   @render, this
    # @footer = @$("footer")
    # @main = $("#main")
    # Tasks.fetch()


  # Add a single task to the list by creating a view for it,
  # and appending its element to the list
  addOne: (task) ->
    view = new app.TaskView(model: task)
    $("#activity-inventory-view tbody").append view.render().el


  # Add all items in the today tasks collection at once
  addAll: ->
    app.activityInventoryTasks.each @addOne


  # If you hit return in the main input field, create a new task
  createTask: (e) ->
    e.preventDefault()
    
    $nameInput = @$form.find("input[name='name']")
    $projectInput = @$form.find("input[name='project']")

    # A task must have a name
    return unless $nameInput.val()

    app.activityInventoryTasks.create {
      name:    $nameInput.val()
      project: $projectInput.val()
    }
    $nameInput.val ""
    $projectInput.val ""


  # Clear all done tasks, destroying their models.
  # clearCompleted: ->
  #   _.each Tasks.done(), (task) ->
  #     task.clear()
  #   return false


  # toggleAllComplete: ->
  #   done = @allCheckbox.checked
  #   Tasks.each (task) ->
  #     task.save done: done

)


# Extend this view with the ManageableView mixin
_.extend(ActivityInventoryView.prototype, app.Mixins.ManageableView)


app.activityInventoryView = new ActivityInventoryView()
