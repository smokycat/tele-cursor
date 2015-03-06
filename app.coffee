FS = require 'fs'
HTTP = require 'http'
WS = require 'socket.io'

SERVER = HTTP.createServer (req, res) ->
  path = req.url.split('?')[0]
  path = '/index.html' if path is '/'
  FS.createReadStream 'public' + path
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

  socket.on "connected", (argName) ->
    socket.emit "welcome", idTable
    name = decodeURIComponent(argName)
      .replace /&/g, '&amp;'
      .replace /</g, '&lt;'
      .replace />/g, '&gt;'
    name = "無名" if name is 'null'
    idTable[id] = name: name, pos: [100, 100]
    tmp = {}
    tmp[id] = idTable[id]
    IO.sockets.emit "connected", tmp

  socket.on "tele-cursor", (data) ->
    return unless idTable[id]
    idTable[id].pos = data
    IO.sockets.emit "tele-cursor", [id, data[0], data[1]]

  socket.on "disconnect", ->
    return unless idTable[id]
    IO.sockets.emit "disconnect", id
    delete idTable[id]

# WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.  WTH Random Walker.
