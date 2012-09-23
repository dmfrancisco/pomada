#
#  Task Model
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#
#= require libs/md5
#

window.app = window.app || {} # Allow scripts to be included in any order


app.Task = Backbone.GSModel.extend(

  # Default attribute values
  defaults:
    state:   ""
    project: ""
    name:    ""
    pomodoros: 0
    interrups: 0


  # Custom getters
  getters:
    # Task colors are not persisted on the server
    # Generate a new color based on the project string
    color: ->
      return utils.colors.generate @get('project')

  initialize: ->
    @on "change", @save # Persist data to the server

)
