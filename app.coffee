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

idTable = {}
nameTable = {}

IO.sockets.on "connection", (socket) ->
  id = socket.id

  socket.on "connected", (name) ->
    idTable[id] = name
    nameTable[name] = true
    IO.sockets.emit "connected", name

  socket.on "tele-cursor", (data) ->
    IO.sockets.emit "tele-cursor", {name: idTable[id], pos: data}

  socket.on "disconnect", ->
    return unless idTable[id]
    IO.sockets.emit "disconnect", idTable[id]
    delete nameTable[idTable[id]]
    delete idTable[id]

# WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.  WTH Random Walker.
