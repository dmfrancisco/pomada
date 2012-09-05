#
#  Custom key events
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#


$(document).keyup (e) ->
    # Unselect tasks
    if e.keyCode == 27 # ESC
        $('.selected').removeClass('selected')
