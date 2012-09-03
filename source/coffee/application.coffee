#
#  Main CoffeeScript file
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#
#= require libs/respond
#= require libs/jquery
#= require libs/jquery-ui
#= require libs/jquery.multisortable
#= require libs/rwd-table
#

# Enable drag and drop

fixHelper = (e, ui) ->
    # This allows the row width to be mantained while dragging elements
    ui.children().each ->
        $(this).width($(this).width())
    return ui

$('#today-tasks tbody, #later-tasks tbody').multisortable({
    items: "tr",
    cursor: 'crosshair',
    opacity: 0.8,
    helper: fixHelper
})

$('#today-tasks tbody').sortable('option', 'connectWith', '#later-tasks tbody')
$('#later-tasks tbody').sortable('option', 'connectWith', '#today-tasks tbody')

dragOutToday = (event, ui) ->
    $("#today-tasks .task").hide()
    $("#later-tasks .task").show()
    $("#new-task").show()
    return false

dragOutLater = (event, ui) ->
    $("#today-tasks .task").show()
    $("#later-tasks .task").hide()
    $("#new-task").hide()
    return false

dragToToday = ->
    $("#today-tasks .task").show()
    $("#later-tasks .task:not(.selected)").hide()
    $("#new-task").hide()
    return false

dragToLater = ->
    $("#today-tasks .task:not(.selected)").hide()
    $("#later-tasks .task").show()
    $("#new-task").show()
    return false

$("#today-page").click dragOutLater
$("#later-page").click dragOutToday

$('#today-page').droppable({
    tolerance: 'pointer',
    over: dragToToday
})

$('#later-page').droppable({
    tolerance: 'pointer',
    over: dragToLater
})

dragOutLater() # Initial state displays the today list

# Responsive table

$("#today-tasks, #later-tasks").table({
    idprefix: "co-",
    persist: "persist"
})


# State

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


# Timer

$('.timer > .type').live 'click', ->
    if $(this).text() == 'POM'
        $(this).text("SRT")
        $(this).attr('title', "Timer for a short break")
        $(this).siblings(".time").text('05')
    else if $(this).text() == 'SRT'
        $(this).text("LNG")
        $(this).attr('title', "Timer for a long break")
        $(this).siblings(".time").text('10')
    else
        $(this).text("POM")
        $(this).attr('title', "Timer for a pomodoro")
        $(this).siblings(".time").text('25')
    return false

$('.start').live 'click', ->
    $(this).find('i').toggleClass('icon-pause')
    $(this).find('i').toggleClass('icon-play')
    $('.stop i').addClass('icon-stop')
    return false

$('.stop').live 'click', ->
    $(this).find('i').removeClass('icon-stop')
    $('.start i').addClass('icon-play').removeClass('icon-pause')
    return false

$('.pomodoro-counter, .interrup-counter').live 'mousedown', (e) ->
    switch e.which
        when 1 # Left mouse button pressed
            $(this).text(parseInt($(this).text()) + 1)
        when 3 # Right mouse button pressed
            e.preventDefault()
            $(this).text(parseInt($(this).text()) - 1)
    return false


# Key events

$(document).keyup (e) ->
    # if e.keyCode == 13 # enter
    if e.keyCode == 27 # esc
        $('.selected').removeClass('selected')


# Send data to server

$('#save-data').click ->
    today = []
    $('#today-tasks tr.task').each ->
        self = $(this)
        j = {}
        j['state']     = self.find('td.state > .box').text()
        j['name']      = self.find('th.name').text()
        j['project']   = self.find('td.project').text()
        j['pomodoros'] = self.find('td.pomodoros .pomodoro-counter').text()
        j['interrups'] = self.find('td.pomodoros .interrup-counter').text()

        today.push(j)

    later = []
    $('#later-tasks tr.task').each ->
        self = $(this)
        j = {}
        j['state']     = self.find('td.state > .box').text()
        j['name']      = self.find('th.name').text()
        j['project']   = self.find('td.project').text()
        j['pomodoros'] = self.find('td.pomodoros .pomodoro-counter').text()
        j['interrups'] = self.find('td.pomodoros .interrup-counter').text()

        later.push(j)

    tasks = {
        'today': today,
        'later': later
    }
    $.post('/save-state', tasks)

$('#save-and-clean-data').click ->
    $('#save-data').trigger('click')
    $('#today-tasks tr.task').each ->
        state = $(this).find('td.state > .box').text()
        if state == '✔' or state == '✕'
            $(this).remove()


# Create new tasks

$('form#new-task').submit ->
    name = $(this).find('input[name="name"]').val()
    project = $(this).find('input[name="project"]').val()

    $task = $("<tr class='task'>
               <td class='state'><div class='box'></div></td>
               <th class='name'>#{ name }</th>
               <td class='project'>#{ project }</td>

               <td class='pomodoros'>
                 <div class='box pomodoro-counter'>0</div>
                 <div class='box interrup-counter'>0</div>
               </td>
               <td class='timer'>
                 <abbr class='type' title='Timer for a pomodoro'>POM</abbr>: <span class='time'>25</span> min
                 <a class='start' href='#'><i class='icon-play'></i></a>
                 <a class='stop'  href='#'><i class=''></i></a>
               </td>
            </tr>")

    $('#later-tasks tbody').append($task)
    $("#later-tasks").removeClass("enhanced") # FIXME

    # Clear the fields
    $(this).find('input[name="name"]').val("")

    return false


# Remove tasks

$('.trash').click ->
    $(this).parent().parent().remove()
    return false

showDeleteButton = (e) ->
    console.log("X")
    if (e.keyCode == 16) # shift
        $('.track').hide()
        $('.trash').show()

showTimerButton = (e) ->
    if (e.keyCode == 16) # shift
        $('.track').show()
        $('.trash').hide()

$(document).keydown showDeleteButton
$(document).keyup showTimerButton
