# Include the required node modules
http = require 'http'
sockets = require 'socket.io'
fs = require 'fs'

# Define the default handler
handler = (request, response) ->

  if request.url == '/'
    index request, response
    return
  else if (/\.(js)$/i).test(request.url)
    jsHandler request, response
    return
  else
    response.writeHead 500
    response.end error_codes[500]
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
# Serve up the javascript files
#

jsHandler = (req, res) ->
  file = __dirname + '/assets/js/' + req.url

  headers = {
    'Content-Type': 'text/javascript'
  }

  fs.readFile file, (err, data) ->
    errorHandler(req, res, 404) if err
    res.writeHead 200, headers
    res.end data
    return


#
# Error handler
#

error_codes = {
  404: "404 Not Found\n",
  500: "Internal server error\n"
}

errorHandler = (req, res, error_code = 404) ->
  res.writeHead error_code
  res.write error_codes[error_code]
  res.end()
  return

# Start the server at port 1337
application = http.createServer(handler).listen(1337)
io = sockets.listen(application)

# SOCKETS

io.sockets.on 'connection', ( socket ) ->

  socket.on 'mousepos', (data) ->
    if data.size && data.size > 10
      data.size = 1

    socket.broadcast.emit 'mousepos', data
    return

  return