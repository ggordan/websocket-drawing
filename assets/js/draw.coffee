jQuery(document).ready ($) ->

  socket = io.connect('http://192.168.1.108:1337')

  canvas = document.getElementById("drawingBoard")
  context = canvas.getContext("2d")
  canvas.width = window.innerWidth - 2;
  canvas.height = window.innerHeight - 2;

  drawline = (x, y, xx, yy, colour, size) ->
    console.log x, y, xx, yy
    context.beginPath()
    context.moveTo(x, y)
    context.lineTo xx, yy
    context.strokeStyle = colour || 3
    context.lineWidth = size || 'red'
    context.stroke()
    return

  # Handle the mouse move events
  socket.on 'mousepos', (data) ->
    drawline data.x, data.y, data.xx, data.yy, data.colour, data.size
    return

  IE = document.all ? true : false
  document.captureEvents(Event.MOUSEMOVE) if !IE

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
      mousexy = { x: @X, y: @Y, xx: e.pageX, yy: e.pageY, colour: $('.colour').val() , size: $('.size').val() }
      context.strokeStyle = $('.colour').val()
      context.lineWidth = $('.size').val()
      context.stroke()

    @X = e.pageX
    @Y = e.pageY

    socket.emit('mousepos', mousexy);
    return
  , 0

  return