#
#  Timer
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#


Timer = { counter: true, $el: true }

Timer.init = ($el) ->
    # Initialize the timer (the text of $el must be an integer that will be decremented)
    Timer.$el = $el # Save this element
    Timer.initialCount = parseInt $el.text() # Save the counter initial value
    Timer.currentCount = Timer.initialCount
    Timer.initialized = true

Timer.start = ->
    timer = ->
        Timer.currentCount -= 1
        Timer.$el.text(Timer.currentCount)
    Timer.counter = setInterval(timer, 1000) # Runs every minute * 60

Timer.stop = ->
    clearInterval Timer.counter

Timer.reset = ->
    Timer.stop()
    Timer.$el.text Timer.initialCount
    Timer.initialized = false


# Start timer

$('.start').live 'click', ->
    # Replace the play icon with a pause icon
    $(this).hide()
    $(this).siblings('.pause').show()

    # Display the reset icon
    $(this).siblings('.reset').show()

    # Initialize and start the timer
    Timer.init($(this).siblings(".time")) unless Timer.initialized
    Timer.start()

    return false


# Reset timer

$('.reset').live 'click', ->
    # Replace the pause icon with a play icon
    $(this).siblings('.start').show()
    $(this).siblings('.pause').hide()

    # Hide the reset icon
    $(this).hide()

    # Reset the timer
    Timer.reset()

    return false


# Pause timer

$('.pause').live 'click', ->
    # Replace the pause icon with a play icon
    $(this).siblings('.start').show()
    $(this).hide()

    # Hide the reset icon
    $(this).siblings('.reset').hide()

    # Stop the timer
    Timer.stop()

    return false


# Switch between timer types

TimerType = {
    setToPomodoro: ($el) ->
        $el.text("POM")
        $el.attr('title', "Timer for a pomodoro")
        $el.siblings(".time").text('25')
        
    setToShortBreak: ($el) ->
        $el.text("SRT")
        $el.attr('title', "Timer for a short break")
        $el.siblings(".time").text('5')
        
    setToLongBreak: ($el) ->
        $el.text("LNG")
        $el.attr('title', "Timer for a long break")
        $el.siblings(".time").text('10')
}

$('.actions .tracker .type').live 'click', ->
    if $(this).text() == 'POM'
        TimerType.setToShortBreak $(this)
    else if $(this).text() == 'SRT'
        TimerType.setToLongBreak $(this)
    else
        TimerType.setToPomodoro $(this)
    return false

TimerType.setToPomodoro $('.actions .tracker .type') # Default value is pomodoro
