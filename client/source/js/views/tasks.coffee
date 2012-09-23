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
    "drop": "sort"
    # "click .toggle":   "toggleDone"
    # "dblclick .view":  "edit"
    # "click a.destroy": "clear"
    # "keypress .edit":  "updateOnEnter"
    # "blur .edit":      "close"


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

    @modelBinder.bind @model, @el, Backbone.ModelBinder.createDefaultBindings(@el, 'data-prop')

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


  close: ->
    @modelBinder.unbind()


  # Remove the item, destroy the model
  clear: ->
    @model.destroy()

)
