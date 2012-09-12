#
#  Tasks View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


# Avoid conflits with server-side ERB templates from middleman
# <%= name %> becomes {{ name }}
_.templateSettings = { interpolate: /\{\{(.+?)\}\}/g }


app.TaskView = Backbone.View.extend(

  tagName:   "tr"
  className: "task"


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
    @model.on "change", @render, this
    @model.on "destroy", @remove, this


  render: ->
    @$el.html @template(@model.toJSON())
    @$el.css { 'background': @model.get('color') }
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
