jQuery(document).ready ($) ->

  touchHandler = (event) ->
    touches = event.changedTouches
    first = touches[0]
    type = "";

    switch event.type
      when "touchstart" then type = "mousedown"
      when "touchmove" then type="mousemove"
      when "touchend" then type="mouseup"
      else return

    simulatedEvent = document.createEvent("MouseEvent");
    simulatedEvent.initMouseEvent(type, true, true, window, 1,
      first.screenX, first.screenY,
      first.clientX, first.clientY, false,
      false, false, false, false, null);

    first.target.dispatchEvent(simulatedEvent);
    event.preventDefault();
    return

  document.addEventListener "touchstart", touchHandler, true
  document.addEventListener "touchmove", touchHandler, true
  document.addEventListener "touchend", touchHandler, true
  document.addEventListener "touchcancel", touchHandler, true

  socket = io.connect('http://localhost:1337')

  canvas = document.getElementById("drawingBoard")
  context = canvas.getContext("2d")
  # Set the canvas size to fll up monitor
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  # function to draw lines from incoming connections
  drawline = (data) ->
    context.beginPath()
    context.moveTo(data.x, data.y)
    context.strokeStyle = data.colour || 3
    context.lineTo data.xx, data.yy
    context.lineWidth = data.size || 'red'
    context.stroke()
    return

  # Handle the mouse move events
  socket.on 'mousepos', (data) ->
    drawline data
    return

  canvas.addEventListener 'mousedown', ->
    @down = true
    return

  canvas.addEventListener 'mouseup', ->
    @down = false
    return

  canvas.addEventListener 'mousemove', (e) ->
    @style.cursor = 'pointer';
    if @down
      context.beginPath()
      context.moveTo(@X, @Y)
      context.lineTo e.pageX , e.pageY
      context.strokeStyle = $('.colour').val() || '#00ff00'
      context.lineWidth = $('.size').val() || 2
      context.stroke()

      mousexy = {
        x: @X,
        y: @Y,
        xx: e.pageX,
        yy: e.pageY,
        colour: $('.colour').val() ,
        size: $('.size').val()
      }

      socket.emit('mousepos', mousexy);

    @X = e.pageX
    @Y = e.pageY
    return
  , 0

  return