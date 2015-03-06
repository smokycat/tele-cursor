FS = require 'fs'
HTTP = require 'http'
WS = require 'socket.io'

SERVER = HTTP.createServer (req, res) ->
  FS.createReadStream 'public' + req.url
  .on 'error', ->
    res.writeHead 404, {"Content-Type":"text/html"}
    res.end '404 not found'
  .on 'open', ->
    res.writeHead 200, {"Content-Type":"text/html"}
    @.pipe res
.listen 3000

IO = WS.listen SERVER

count = 0
idTable = {}

IO.sockets.on "connection", (socket) ->
  id = ++count

  socket.on "connected", (name) ->
    idTable[id] = name
    IO.sockets.emit "connected", {id: id, name: name}

  socket.on "tele-cursor", (data) ->
    IO.sockets.emit "tele-cursor", [id, data[0], data[1]]

  socket.on "disconnect", ->
    return unless idTable[id]
    IO.sockets.emit "disconnect", id
    delete idTable[id]

# WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.  WTH Random Walker.
