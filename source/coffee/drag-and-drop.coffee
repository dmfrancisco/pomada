#
#  Enable and config task drag and drop
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#


DragAndDrop = {
    # This allows the row width to be mantained while dragging elements
    # FIXME This only works when a single task is dragged
    fixWidthHelper: (e, ui) ->
        ui.children().each ->
            $(this).width($(this).width())
        return ui

    # This method hides contents to simulate a page transition.
    # If we are dragging a task to the today page, we cannot hide the activity inventory page,
    # otherwise the dragged task would disappear. So, we display the today page and hide everything
    # except the selected tasks from the activity inventory page. (& vice-versa)
    dragToToday: ->
        $("#today-page").show()
        $(".tasks .task").show()
        $("#activity-inventory-page > .tasks .task:not(.selected)").hide()
        $("#activity-inventory-page .container-aux").hide() # Hide other components on the page

    dragToLater: ->
        $("#activity-inventory-page").show()
        $(".tasks .task").show()
        $("#today-page > .tasks .task:not(.selected)").hide()
        $("#today-page .container-aux").hide() # Hide other components on the page

    dropped: ->
        $(".tasks").removeClass("enhanced") # FIXME Currently, adding
        # rows to the table breaks rwd-table, so here i'm disabling it

        $(".tasks .task").show()
        $(".container-aux").show()
        Pomada.runRoute("get", window.location.pathname)
}


# Enable drag and drop

$('.tasks tbody').multisortable({
    items: "tr",
    cursor: 'crosshair',
    opacity: 0.8,
    helper: DragAndDrop.fixWidthHelper
})


# Connect the later tasks table to the today table to drag-and-drop tasks between both

$('#today-page > .tasks tbody').sortable('option', 'connectWith', '#activity-inventory-page > .tasks tbody')
$('#activity-inventory-page > .tasks tbody').sortable('option', 'connectWith', '#today-page > .tasks tbody')


# Allow to drag tasks between pages

$('a[href="/today"]').droppable({
    tolerance:  'pointer',
    over:       DragAndDrop.dragToToday, # Triggered when the mouse is over the tab
    deactivate: DragAndDrop.dropped      # Triggered when the element is dropped
})

$('a[href="/activity-inventory"]').droppable({
    tolerance:  'pointer',
    over:       DragAndDrop.dragToLater, # Triggered when the mouse is over the tab
    deactivate: DragAndDrop.dropped      # Triggered when the element is dropped
})


# Don't break the contentEditable control

$('#today-page > .tasks').find('.name, .project, .time').bind 'click', ->
    $(this).focus()

$('#activity-inventory-page > .tasks').find('.name, .project, .time').bind 'click', ->
    $(this).focus()
