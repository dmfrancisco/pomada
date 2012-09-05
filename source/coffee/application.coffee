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
#= require drag-and-drop
#= require rwd-tables
#= require manage-tasks
#= require timer
#= require persistence
#= require key-events
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
        Helpers.hidePages()

    # Application routes

    @get '/', ->
        @redirect '/today'

    @get '/today', ->
        $('#today-page').show()

    @get '/activity-inventory', ->
        $('#activity-inventory-page').show()

    @get '/records', ->
        $('#records-page').show()


# Start the application
Pomada.run(window.location.pathname)


# Export the app has a global object
window.Pomada = Pomada
