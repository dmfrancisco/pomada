#
#  Today View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


TodayView = Backbone.SortableListView.extend(

  el: $("#today-view")
  $sortable: $("#today-view .tasks tbody")


  # At initialization we bind to the relevant events on the TodayTasks
  # collection, when items are added or changed. Kick things off by
  # loading any existing tasks that might exist
  initialize: (options) ->
    # Call parent's constructor
    @constructor.__super__.initialize.apply this, [options]

    # The managerFactory helps to generate element managers
    # An element manager creates/removes elements when models are added to a collection
    viewCreator = (model) -> new app.TaskView(model: model)
    managerFactory = new Backbone.CollectionBinder.ViewManagerFactory(viewCreator)
    @collectionBinder = new Backbone.CollectionBinder(managerFactory, autoSort: true)
    @collectionBinder.bind @collection, @$('tbody')

    # Bind to relevant events
    @collection.on "add reset", @refreshSortable, this

    # Fetch existing tasks
    @collection.fetch()

)


# Extend this view with the ManageableView mixin
_.extend(TodayView.prototype, app.Mixins.ManageableView)


app.todayView = new TodayView({ collection : app.todayTasks })
