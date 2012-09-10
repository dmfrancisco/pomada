#
#  Main CoffeeScript file
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#
#= require libs/respond
#= require libs/jquery.multisortable
#= require libs/jquery.mustache
#= require libs/underscore.min
#= require libs/backbone.min
#= require libs/backbone-localstorage
#


# Avoid conflits with server-side ERB templates from middleman
# <%= name %> becomes {{ name }}
_.templateSettings = { interpolate: /\{\{(.+?)\}\}/g }


# Task Router
# -----------

Router = Backbone.Router.extend(

  routes:
    "today": "today",
    "activity-inventory": "activity-inventory",
    "records": "records"

  help: ->
    # ...

  search: (query, page) ->
    # ...

)

TaskRouter = new Router()
Backbone.history.start()


# Task Model
# ----------

Task = Backbone.Model.extend(

  # Default attributes for the task
  defaults: ->
    title: ""
    order: Task.nextOrder()
    state: "done"


  # Ensure that each task has `title`
  initialize: ->
    @set({ title: @defaults.title }) unless @get("title")


  # Remove this task from *localStorage* and delete its view
  clear: ->
    @destroy()

)


# Task Collection
# ---------------

TaskList = Backbone.Collection.extend(

  # Reference to this collection's model
  model: Task


  # Save all of the tasks under the "tasks" namespace
  localStorage: new Store("tasks-backbone")


  # Filter down the list of all tasks that are done or canceled
  # completed: ->
  #   @filter (task) ->
  #     task.get("done")


  # Filter down the list to only tasks that are still not finished
  # remaining: ->
  #   @without.apply this, @done()


  # We keep tasks in sequential order, despite being saved by unordered
  # GUID in the database. This generates the next order number for new items
  nextOrder: ->
    return 1 unless @length
    @last().get("order") + 1


  # Tasks are sorted by their original insertion order
  comparator: (task) ->
    task.get "order"

)


# Create a global collection of **Tasks**
Tasks = new TaskList


# Task View
# --------------

TaskView = Backbone.View.extend(

  tagName: "tr"

  # Cache the template function for a single task
  template: _.template($("#task-template").html())

  # The DOM events specific to a task
  # events:
  #   "click .toggle":   "toggleDone"
  #   "dblclick .view":  "edit"
  #   "click a.destroy": "clear"
  #   "keypress .edit":  "updateOnEnter"
  #   "blur .edit":      "close"


  # The TaskView listens for changes to its model, re-rendering. Since there's
  # a one-to-one correspondence between a **Task** and a **TaskView** in this
  # app, we set a direct reference on the model for convenience
  initialize: ->
    @model.bind("change", @render, this)
    @model.bind("destroy", @remove, this)


  # Re-render the titles of the task
  render: ->
    @$el.html @template(@model.toJSON())
    # @$el.toggleClass "done", @model.get("done")
    # @input = @$(".edit")
    return this


  # Toggle the `"done"` state of the model
  # toggleDone: ->
  #   @model.toggle()


  # Switch this view into `"editing"` mode, displaying the input field
  # edit: ->
  #   @$el.addClass "editing"
  #   @input.focus()


  # Close the `"editing"` mode, saving changes to the task
  # close: ->
  #   value = @input.val()
  #   @clear()  unless value
  #   @model.save title: value
  #   @$el.removeClass "editing"


  # If you hit `enter`, we're through editing the item
  # updateOnEnter: (e) ->
  #   @close()  if e.keyCode is 13


  # Remove the item, destroy the model
  clear: ->
    @model.clear()

)

# The Application
# ---------------

# The overall **AppView** is the top-level piece of UI
AppView = Backbone.View.extend(

  # Instead of generating a new element, bind to the existing skeleton of
  # the App already present in the HTML.
  el: $("#pomada")

  # Our template for the line of statistics at the bottom of the app.
  # statsTemplate: _.template($("#stats-template").html())

  # Delegated events for creating new items, and clearing completed ones.
  events:
    "keypress #new-task":     "createOnEnter"
    "click #clear-completed": "clearCompleted"
    "click #toggle-all":      "toggleAllComplete"


  # At initialization we bind to the relevant events on the `Tasks`
  # collection, when items are added or changed. Kick things off by
  # loading any preexisting tasks that might be saved in *localStorage*.
  initialize: ->
    @input = @$("#new-task")
    @allCheckbox = @$("#toggle-all")[0]
    Tasks.bind "add",   @addOne, this
    Tasks.bind "reset", @addAll, this
    Tasks.bind "all",   @render, this
    @footer = @$("footer")
    @main = $("#main")
    Tasks.fetch()


  # Re-rendering the App just means refreshing the statistics -- the rest
  # of the app doesn't change.
  render: ->
    done = Tasks.done().length
    remaining = Tasks.remaining().length
    if Tasks.length
      @main.show()
      @footer.show()
      # @footer.html @statsTemplate(
      #   done: done
      #   remaining: remaining
      # )
    else
      @main.hide()
      @footer.hide()
    @allCheckbox.checked = not remaining


  # Add a single task to the list by creating a view for it, and
  # appending its element to the `<ul>`.
  addOne: (task) ->
    view = new TaskView(model: task)
    @$("#task-list").append view.render().el


  # Add all items in the **Tasks** collection at once.
  addAll: ->
    Tasks.each @addOne


  # If you hit return in the main input field, create new **Task** model,
  # persisting it to *localStorage*.
  # createOnEnter: (e) ->
  #   return unless e.keyCode is 13
  #   return unless @input.val()
  #   Tasks.create title: @input.val()
  #   @input.val ""


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


# Finally, we kick things off by creating the **App**.
App = new AppView
