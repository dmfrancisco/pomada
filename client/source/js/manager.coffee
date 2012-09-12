#
#  Region Manager (based on goo.gl/AW8qJ)
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


RegionManager = ->

  currentView = undefined
  region = {}

  closeView = (view) ->
    view.close() if view and view.close

  openView = (view) ->
    view.render()
    view.open() if view.open

  region.show = (view) ->
    closeView(currentView)
    currentView = view
    openView(currentView)

  return region


app.regionManager = new RegionManager()
