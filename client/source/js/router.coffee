#
#  Task Router
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


TaskRouter = Backbone.Router.extend(

  routes:
    "today":              "today"
    "activity-inventory": "activityInventory"
    "records":            "records"
    "*action":            "defaultRoute"


  today: ->
    console.log "Visiting today"
    app.regionManager.show(app.todayView)

  activityInventory: ->
    console.log "Visiting activity inventory"
    app.regionManager.show(app.activityInventoryView)

  records: ->
    console.log "Visiting records"
    app.regionManager.show(app.recordsView)


  # The root url redirects to the today page
  # The trigger option calls the route function
  # The replace option updates the URL without creating an entry in browser's history
  defaultRoute: (action) ->
    app.taskRouter.navigate('today', { trigger: true, replace: true })

)


app.taskRouter = new TaskRouter()
Backbone.history.start()
