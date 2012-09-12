#
#  Records View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


RecordsView = Backbone.View.extend(

  el: $("#records-view")

)


# Extend this view with the ManageableView mixin
_.extend(RecordsView.prototype, app.Mixins.ManageableView)


app.recordsView = new RecordsView()
