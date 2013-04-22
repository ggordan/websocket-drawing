jQuery(document).ready ($) ->

  socket = io.connect('http://192.168.1.108:1337')

  canvas = document.getElementById("sh")
  context = canvas.getContext("2d")

  drawline = (x, y, xx, yy) ->
    c = document.getElementById("sh")
    ctx = c.getContext("2d")
    console.log x, y, xx, yy
    ctx.beginPath()
    ctx.moveTo(x, y)
    ctx.lineTo xx, yy
    context.strokeStyle = @color
    ctx.stroke()
    return

  # Handle the mouse move events
  socket.on 'mousepos', (data) ->
    drawline data.x, data.y, data.xx, data.yy
    return

  IE = document.all ? true : false
  document.captureEvents(Event.MOUSEMOVE) if !IE

  HTMLCanvasElement.prototype.points = (x,y) ->
    @cx = x
    @cy = y
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
      mousexy = { x: @X, y: @Y, xx: e.pageX, yy: e.pageY }
      context.lineTo e.pageX , e.pageY
      context.strokeStyle = @color
      context.stroke()
    @X = e.pageX
    @Y = e.pageY

    socket.emit('mousepos', mousexy);
    return
  , 0

  return