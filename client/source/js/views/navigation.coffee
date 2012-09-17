#
#  Navigation View
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order


NavigationView = Backbone.View.extend(

  el: $("#navigation-view")


  # If we are dragging a task to the today page, we cannot hide the activity inventory page,
  # otherwise the dragged task would disappear. So, we display the today page and hide everything
  # except the selected tasks from the activity inventory page. (& vice-versa)
  dragToToday: ->
    app.taskRouter.navigate('today', { trigger: true })
    $("#activity-inventory-view > .tasks .task.selected").css('visibility', 'visible')

  dragToActivityInventory: ->
    app.taskRouter.navigate('activity-inventory', { trigger: true })
    $("#today-view > .tasks .task.selected").css('visibility', 'visible')

  dropped: ->
    $(".tasks .task").css('visibility', 'auto')


  initialize: ->
    # Enable drag tasks between pages

    @$el.find('a[href="#today"]').droppable
      tolerance: 'pointer',
      over: @dragToToday, # Triggered when the mouse is over the tab
      drop: @dropped # Triggered when the element is dropped

    @$el.find('a[href="#activity-inventory"]').droppable
      tolerance: 'pointer',
      over: @dragToActivityInventory, # Triggered when the mouse is over the tab
      drop: @dropped # Triggered when the element is dropped

)

app.navigationView = new NavigationView()
