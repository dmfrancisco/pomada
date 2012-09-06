#
#  Generate colors for each project
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#= require libs/md5
#

memo = {}
generateColor = (string) ->
    return memo[string] if memo[string] # Memoization
    color = calcMD5(string) # Generates an hexadecimal value with 32 chars
    
    i = 30
    while i -= 1
        # We want to avoid dark colors
        if parseInt(color[0], 16) + parseInt(color[2], 16) + parseInt(color[4], 16) <= 15
            color = color.substring(1)

    color = color.substring(0, 6) # Valid hexadecimal color
    return memo[string] = color

$('.task').each ->
    project = $(this).find('.project').text()
    color = generateColor(project)
    $(this).children("td:first").css('border-left', "1px solid ##{ color }")
