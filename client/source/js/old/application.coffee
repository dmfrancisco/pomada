#
#  Main CoffeeScript file
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#
#= require libs/respond
#= require libs/jquery.multisortable
#= require libs/rwd-table
#= require libs/jquery.mustache
#= require libs/sammy-latest.min
#= require libs/underscore.min
#= require libs/backbone.min
#= require libs/backbone-localstorage
#= require drag-and-drop
#= require rwd-tables
#= require manage-tasks
#= require timer
#= require persistence
#= require key-events
#= require colors
#


# Some helpers

Helpers = {
    # Hide all pages
    hidePages: ->
        $('[data-role="page"]').hide()
}


# Initialize the application
Pomada = Sammy '#main', ->

    # Before filters

    @before { except: {} }, ->
        $('.navbar a').removeClass("active")
        Helpers.hidePages()

    # Application routes

    @get '/', ->
        @redirect '/today'

    @get '/today', ->
        $('.navbar a[href="/today"]').addClass("active")
        $('#today-page').show()
        displayScrollbarHint()

    @get '/activity-inventory', ->
        $('.navbar a[href="/activity-inventory"]').addClass("active")
        $('#activity-inventory-page').show()
        displayScrollbarHint()

    @get '/records', ->
        $('.navbar a[href="/records"]').addClass("active")
        $('#records-page').show()
        displayScrollbarHint()


# Start the application
Pomada.run(window.location.pathname)


# Export the app has a global object
window.Pomada = Pomada


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

$(window).scroll(displayScrollbarHint).trigger('scroll')
