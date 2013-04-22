# Include the required node modules
http = require 'http'
sockets = require 'socket.io'
fs = require 'fs'

# Define the default handler
handler = (request, response) ->

  if request.url == '/'
    index request, response
    return
  else if request.url == '/draw.js'
    jsResponse request, response
    return
  else
    response.writeHead 500
    response.end "Error"
    return

  return


#
# Serve up index page
#
index = (req, res) ->

  template = __dirname + '/index.html'

  fs.readFile template, (err, data) ->
    errorHandler(req, res) if err
    res.writeHead 200
    res.end data
    return


#
# Serve up the javascript file
#
jsResponse = (req, res) ->

  template = __dirname + '/draw.js'

  headers = {
    'Content-Type': 'text/javascript'
  }

  fs.readFile template, (err, data) ->
    errorHandler(req, res) if err
    res.writeHead 200, headers
    res.end data
    return


#
# Error handler
#
errorHandler = (req, res) ->

  res.writeHead 404, headers
  res.write "404 Not Found\n"
  res.end()

  return

# Start the server at port 1337
application = http.createServer(handler).listen(1337)
io = sockets.listen(application)

# SOCKETS

io.sockets.on 'connection', ( socket ) ->
  socket.join 'mouse_movers'
  socket.on 'mousepos', (data) ->
    socket.broadcast.emit 'mousepos', data
    return
  return