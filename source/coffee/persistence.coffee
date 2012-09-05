#
#  Send data to the server for persistence
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#


# Send all tasks to the server

$('.save-data').click ->
    today = []
    $('#today-page > .tasks .task').each ->
        self = $(this)
        j = {}
        j['state']     = self.find('.state > .box').text()
        j['name']      = self.find('.name').text()
        j['project']   = self.find('.project').text()
        j['pomodoros'] = self.find('.counters .pomodoro-counter').text()
        j['interrups'] = self.find('.counters .interrup-counter').text()

        today.push(j)

    later = []
    $('#activity-inventory-page > .tasks .task').each ->
        self = $(this)
        j = {}
        j['state']     = self.find('.state > .box').text()
        j['name']      = self.find('.name').text()
        j['project']   = self.find('.project').text()
        j['pomodoros'] = self.find('.counters .pomodoro-counter').text()
        j['interrups'] = self.find('.counters .interrup-counter').text()

        later.push(j)

    $.post('/save/state', { 'today': today, 'later': later })
    return false


# Send all completed and canceled tasks of the day

$('.log-completed').click ->
    today = []
    $('#today-page > .tasks .task').each ->
        $self = $(this)
        j = {}
        j['state']     = $self.find('.state > .box').text()
        j['name']      = $self.find('.name').text()
        j['project']   = $self.find('.project').text()
        j['pomodoros'] = $self.find('.counters .pomodoro-counter').text()
        j['interrups'] = $self.find('.counters .interrup-counter').text()

        if j['state'] == '✔' or j['state'] == '✕'
            today.push(j)
            $self.remove()

    $.post('/save/record', { 'record': today })
    $('.save-data').trigger('click')
    return false
