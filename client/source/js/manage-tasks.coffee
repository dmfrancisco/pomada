#
#  Manage tasks
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#


# Change task state

$('.state .box').live 'click', ->
    if $(this).text() == '✔'
        $(this).text("✕")
        $(this).parent().siblings(".name").addClass('canceled')
    else if $(this).text() == '✕'
        $(this).text(" ")
        $(this).parent().siblings(".name").removeClass('canceled')
    else
        $(this).text("✔")
        $(this).parent().siblings(".name").removeClass('canceled')
    return false


# Add and remove pomodoros and interruptions

$('.pomodoro-counter, .interrup-counter').live 'mousedown', (e) ->
    switch e.which
        when 1 # Left mouse button pressed
            $(this).text(parseInt($(this).text()) + 1)
        when 3 # Right mouse button pressed
            e.preventDefault()
            $(this).text(parseInt($(this).text()) - 1)
    return false


# Create new tasks

$('form#new-task').submit ->
    $self = $(this)
    name = $self.find('input[name="name"]').val()
    project = $self.find('input[name="project"]').val()

    # Retrieve the template for a task (TODO Activate cache)
    $.get '/templates/task.mustache', (template) ->
        $task = $.mustache(template, {
            name: name,
            project: project,
            pomodoros: 0,
            interrups: 0
        })

        # Append the task to the table
        $('#activity-inventory-page > .tasks tbody').append($task)
        $("#activity-inventory-page > .tasks").removeClass("enhanced") # FIXME Currently, adding
        # rows to the table breaks rwd-table, so here i'm disabling it

        # Clear the fields
        $self.find('input[name="name"]').val("")

    return false


# Remove tasks

$('.trash').on 'click', ->
    $(this).parent().parent().remove()
    return false

showDeleteButton = (e) ->
    if (e.keyCode == 16) # shift
        $('.tracker').hide()
        $('.trash').show()

showTimerButton = (e) ->
    if (e.keyCode == 16) # shift
        $('.tracker').show()
        $('.trash').hide()

$(document).keydown showDeleteButton
$(document).keyup showTimerButton
