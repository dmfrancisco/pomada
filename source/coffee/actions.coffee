#
#  Actions
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#


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

$('.actions > .type').live 'click', ->
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

counter = true

$('.start').live 'click', ->
    $(this).find('i').toggleClass('icon-pause')
    $(this).find('i').toggleClass('icon-play')
    $('.stop i').addClass('icon-stop')

    $time = $(this).siblings(".time")
    count = parseInt($time.text())

    timer = ->
        count -= 1
        $time.text(count)

    counter = setInterval(timer, 1000 * 60) # runs every minute
    return false

$('.stop').live 'click', ->
    $(this).find('i').removeClass('icon-stop')
    $('.start i').addClass('icon-play').removeClass('icon-pause')
    clearInterval(counter)
    return false

$('.pomodoro-counter, .interrup-counter').live 'mousedown', (e) ->
    switch e.which
        when 1 # Left mouse button pressed
            $(this).text(parseInt($(this).text()) + 1)
        when 3 # Right mouse button pressed
            e.preventDefault()
            $(this).text(parseInt($(this).text()) - 1)
    return false
