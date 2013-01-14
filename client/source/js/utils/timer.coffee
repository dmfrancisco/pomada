#
#  Gauge chart for the timer using Canvas and JavaScript
#  From goo.gl/pAaeN by Ruby On Tails
#

window.utils = window.utils || {} # Allow scripts to be included in any order


utils.Timer = ($el = $(".gauge"), options = {}) ->

  options.primaryColor = "#0BA8D1" # "#8CC003"

  settings = $.extend({}, {
     minutesUntilFinished: 10 # 1
     bgdColor:     "#191919"
     primaryColor: "#e9df6e"
     tick: 1000 # * 60 # 1 minute
     type: "countup" # "countdown"
  }, options)

  canvas = $el[0]
  ctx = canvas.getContext("2d")
  W = canvas.width
  H = canvas.height

  text           = undefined
  animation_loop = undefined
  redraw_loop    = undefined
  stepdegrees    = 0

  if settings.type == 'countup'
    degrees     = 0
    currentTime = 0
  else if settings.type == 'countdown'
    degrees     = 360
    currentTime = settings.minutesUntilFinished * settings.tick

  init = ->
    # Clear the canvas everytime a chart is drawn
    ctx.clearRect 0, 0, W, H

    # Background 360 degree arc
    ctx.beginPath()
    ctx.strokeStyle = settings.bgdColor
    ctx.lineWidth = 40
    ctx.arc W / 2, H / 2, 100, 0, Math.PI * 2, false # You can see the arc now
    ctx.stroke()

    # Gauge will be a simple arc
    # Angle in radians = angle in degrees * PI / 180
    radians = degrees * Math.PI / 180
    ctx.beginPath()
    ctx.strokeStyle = settings.primaryColor
    ctx.lineWidth = 41

    # The arc starts from the rightmost end. If we deduct 90 degrees from the angles
    # the arc will start from the topmost end
    ctx.arc W / 2, H / 2, 100, 0 - 90 * Math.PI / 180, radians - 90 * Math.PI / 180, false

    # You can see the arc now
    ctx.stroke()

    # Lets add the text
    ctx.fillStyle = settings.bgdColor
    ctx.font = "50px 'Droid Sans Mono'"
    text = ""+ Math.floor(currentTime / settings.tick) # * 60 # Math.floor(degrees / 360.0 * settings.minutesUntilFinished)

    # Lets center the text
    # deducting half of text width from position x
    text_width = ctx.measureText(text.replace("-", "--")).width # Count twice the space for the minus sign (for better alignment)

    # Adding manual value to position y since the height of the text cannot
    # be measured easily. There are hacks but we will keep it manual for now.
    ctx.fillText text, W / 2 - text_width / 2, H / 2 + 15


  draw = ->
    # Cancel any movement animation if a new chart is requested
    clearInterval(animation_loop) unless typeof animation_loop is `undefined`

    # Step degree from 0 to 360
    stepdegrees = 360.0 / (settings.minutesUntilFinished ) # * 60

    # This will animate the gauge to new positions
    # Each step will take 10 second
    animation_loop = setInterval(animate_to, settings.tick)
    animate_to()


  # Function to make the chart move to new degrees
  animate_to = ->
    # Clear animation loop if degrees reaches to maxdegrees
    # return clearInterval(animation_loop) if degrees >= maxdegrees

    if settings.type == 'countup'
      degrees = Math.min(degrees + stepdegrees, 360)
      currentTime += settings.tick
    else if  settings.type == 'countdown'
      degrees = Math.max(degrees - stepdegrees, 0)
      currentTime -= settings.tick

    # The timer reached the end at least once
    if currentTime % (settings.minutesUntilFinished * settings.tick) == 0
      $el.trigger("times-up", currentTime / (settings.minutesUntilFinished * settings.tick))
    init()


  # Clear animation loop
  stop = ->
    clearInterval(animation_loop)


  # Lets add some animation for fun
  draw()

  return true


# Use it like this:
myTimer = new utils.Timer()
