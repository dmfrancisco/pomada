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


app.TaskView = Backbone.SortableItemView.extend(

  tagName:   "tr"
  className: "task"


  # Cache the template function for a single task
  html: $("#task-template").html()


  # The DOM events specific to a task
  events:
    "drop":              "sort"
    "click .state .box": "toggleState"
    "click .trash":      "clear"
    "mousedown .pomodoro-counter": "setPomodoros"
    "mousedown .interrup-counter": "setInterrups"
    "mousedown .estimate-counter": "setEstimate"


  # The TaskView listens for changes to its model, re-rendering. Since there's
  # a one-to-one correspondence between a **Task** and a **TaskView** in this
  # app, we set a direct reference on the model for convenience
  initialize: ->
    self = this
    @model.on "destroy", @remove, this # Remove the view from the DOM

    # Enable the contentEditable control
    # (this is necessary to override the jquery sortable default behavior)
    @$el.find('.name, .project, .time').live 'click', ->
      $(this).focus()

    # Unselect tasks when the escape key is pressed
    $(document).keyup (e) ->
      if e.keyCode == 27
        $('.selected').removeClass('selected')

    _.bindAll(this)
    @modelBinder = new Backbone.ModelBinder()


  render: ->
    @$el.html @html
    @$el.children("td:first").css { 'border-left-color': @model.get('color') }

    # Add the cid to the DOM. This is an hack for the multisortable plugin. The data
    # attribute is not stored on the element by jQuery. It's actually stored in $.cache.
    @$el.data 'cid', @model.cid

    @$el.find(".name").addClass('canceled') if @model.get('state') == '✕'

    @modelBinder.bind @model, @el, Backbone.ModelBinder.createDefaultBindings(@el, 'data-prop')

    return this


  # Toggle the `"done"` state of the model
  toggleState: (event) ->
    state = @model.get('state')

    if state == '✔'
        @model.set("state", "✕")
        @$el.find(".name").addClass('canceled')
    else if state == '✕'
        @model.set("state", " ")
        @$el.find(".name").removeClass('canceled')
    else
        @model.set("state", "✔")
        @$el.find(".name").removeClass('canceled')


  updateCounter: (attribute, event) ->
    switch event.which
      when 1 # Left mouse button pressed
        @model.set(attribute, @model.get(attribute) + 1)
      when 3 # Right mouse button pressed
        event.preventDefault()
        @model.set(attribute, @model.get(attribute) - 1)


  setPomodoros: (event) ->
    @updateCounter "pomodoros", event


  setInterrups: (event) ->
    @updateCounter "interrups", event


  setEstimate: (event) ->
    @updateCounter "estimate", event


  close: ->
    @modelBinder.unbind()


  # Remove the item, destroy the model
  clear: ->
    @model.destroy()

)
