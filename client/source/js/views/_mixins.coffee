#
#  Mixins for views
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order
app.Mixins = app.Mixins || {}


# To be used with a Region Manager (based on goo.gl/AW8qJ)
app.Mixins.ManageableView = {

  open: ->
    @$el.removeClass("hidden")

    # Since views are hidden using the visibility property
    # instead of the display property, and since visibility
    # retains the element's dimensional space, we move the
    # view in the DOM to the end. This is important to support
    # dragging tasks between views
    $parent = @$el.parent()
    $view   = @$el.detach()
    $parent.prepend $view

  close: ->
    @$el.addClass("hidden")

}


# This is not a mixin but a parent view
Backbone.SortableListView = Backbone.View.extend(

  $sortable: $("tbody")
  items: "tr" # Specifies which items inside the element should be sortable


  # In child views call parent's constructor like this:
  # @constructor.__super__.initialize.apply this, [options]
  initialize: (options) ->
    # Enable drag and drop
    @$sortable.multisortable
      items:   @items
      cursor:  "crosshair"
      opacity: 0.8
      helper:  utils.dragDrop.fixWidthHelper

    # Support connection with other lists
    @on "connect", @connect, this

    # Update elements' order when element is sorted inside sortable.
    #
    # The following will not work: @$sortable.bind('sortstop', callback).
    # The multisortable plugin runs code after the sortable 'sortstop' event
    # is called. Thus, if we update the elements order when the event is triggered,
    # we are doing it too soon. Passing a 'stop' option in the above options hash
    # will also not work due to a bug in the multisortable implementation.
    # Our only option is to get the "stop" function implemented in the multisortable
    # plugin and call it manually inside our reimplementation.
    self = this
    originalStopFx = @$sortable.sortable "option" , "stop"
    @$sortable.sortable "option" , "stop" , (event, ui) ->
      originalStopFx(event, ui) # Call the original implementation

      # Check if element was dropped from another connected sortable
      connectedSortable = self.el != ui.item.parents("section")[0]
      ui.item.trigger 'drop', [ui.item.index(), connectedSortable] # Reorder

    # The sorted item will trigger this event
    utils.pubsub.bind "update-sort", @sort, this


  # Refresh sortable list with dynamically appended elements
  # Use it like this: modelInstance.on("add", @updateSortable, this)
  refreshSortable: ->
    @$sortable.multisortable 'refresh'


  # Connect these elements with another list in
  # order to drag-and-drop elements between both
  # Use it like this: view1.trigger("connect", view2)
  connect: (view) ->
    @connectedCollection = view.collection
    @$sortable.sortable 'option', 'connectWith', view.$sortable


  # Update the elements order
  # newPosition contains the new position of the dropped element
  sort: (params) ->
    model = params[0]
    newPosition = params[1]
    connectedSortable = params[2]

    # The following code does not work when dropping multiple elements
    #
    # oldPosition = model.get('order')
    #
    # # An element has moved inside the list
    # if not connectedSortable and not _.isUndefined(@collection.getByCid(model.cid))
    #   @collection.remove model, { silent: true }
    #
    #   @collection.each (model) ->
    #     order = model.get('order')
    #     model.set('order', order - 1) if oldPosition < order <= newPosition and oldPosition < newPosition
    #     model.set('order', order + 1) if oldPosition > order >= newPosition and oldPosition > newPosition
    #
    #   model.set('order', newPosition)
    #   @collection.add model, { silent: true }
    #
    #
    # # An element was dropped from a connected list
    # else if connectedSortable and _.isUndefined(@collection.getByCid(model.cid))
    #   @collection.each (model) ->
    #     order = model.get('order')
    #     model.set('order', order + 1) if order >= newPosition
    #
    #   # We don't want to render since the sortable widget already does it visually
    #   model.set('order', newPosition)
    #   @collection.add model, { silent: true }
    #
    #
    # # An element was dropped out from the list
    # else if connectedSortable
    #   @collection.remove model, { silent: true }
    #
    #   @collection.each (model) ->
    #     order = model.get('order')
    #     model.set('order', order - 1) if order >= oldPosition


    # Quick fix to work with multiple elements
    # This is a bad implementation since it relies on the DOM

    needsSorting = false
    self = this

    # An element has moved inside the list
    if not connectedSortable and not _.isUndefined(@collection.getByCid(model.cid))
      needsSorting = true

    # An element was dropped from a connected list
    else if connectedSortable and _.isUndefined(@collection.getByCid(model.cid))
      needsSorting = true

      @$el.find('.selected').each ->
        model = self.connectedCollection.getByCid $(this).data('cid')
        self.collection.add model, { silent: true }

    # An element was dropped out from the list
    else if connectedSortable
      needsSorting = true

      $('.selected').each ->
        model = self.collection.getByCid $(this).data('cid')
        self.collection.remove model, { silent: true }

    if needsSorting
      @$el.find(@items).each (index) ->
        model = self.collection.getByCid $(this).data('cid')
        model.set('order', index) if model

      @collection.sort { silent: true }

    # Prints, for debugging
    # console.log ">> #{ JSON.stringify(@collection.toJSON()) }"
    #
    # @collection.each (model, order) ->
    #   console.log "Model #{ model.get('name') } has now order #{ model.get('order') }"

)


# Simple view for each list item
Backbone.SortableItemView = Backbone.View.extend(

  sort: (event, params...) ->
    params.unshift @model # Add model to the parameters list
    utils.pubsub.trigger "update-sort", params

)
