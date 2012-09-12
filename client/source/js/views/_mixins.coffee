#
#  Mixins for views
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order
app.Mixins = app.Mixins || {}


app.Mixins.ManageableView = {

  open: ->
    @$el.show()

  close: ->
    @$el.hide()

}
