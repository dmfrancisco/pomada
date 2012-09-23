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
#= require libs/Backbone.ModelBinder.js
#= require libs/Backbone.ModelBinder.js
#= require libs/Backbone.CollectionBinder.js
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


# All empty links should not update the url

$('a[href="#"]').click ->
  return false


# Show shadow to indicate the user can scroll

displayScrollbarHint = ->
    if $(window).scrollTop() > 50
        $('.top-shadow').css({ 'opacity': 1 })
    else
        $('.top-shadow').css({ 'opacity': 0 })

    if $('body').height() - $('body').scrollTop() - $(window).height() > 50
        $('.bottom-shadow').css({ 'opacity': 1 })
    else
        $('.bottom-shadow').css({ 'opacity': 0 })
    return false

$(window).scroll displayScrollbarHint # Update when user scrolls
$(window).bind 'hashchange', displayScrollbarHint # Update when user changes view
displayScrollbarHint()
