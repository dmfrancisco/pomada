#
#  Task Router
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


TaskRouter = Backbone.Router.extend(

  routes:
    "":                   "root",
    "today":              "today",
    "activity-inventory": "activityInventory",
    "records":            "records"


  # The root url redirects to the today page
  # The trigger option calls the route function
  # The replace option updates the URL without creating an entry in browser's history
  root: ->
    app.taskRouter.navigate('today', { trigger: true, replace: true })

  today: ->
    console.log "Visiting today"
    app.regionManager.show(app.todayView)

  activityInventory: ->
    console.log "Visiting activity inventory"
    app.regionManager.show(app.activityInventoryView)

  records: ->
    console.log "Visiting records"
    app.regionManager.show(app.recordsView)

)


app.taskRouter = new TaskRouter()
Backbone.history.start()
