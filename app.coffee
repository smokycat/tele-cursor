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

userHash = {}

IO.sockets.on "connection", (socket) ->
  socket.on "connected", (name) ->
    msg = name + "が入室しました"
    userHash[socket.id] = name
    IO.sockets.emit("tele-cursor", {value: msg})

  socket.on "tele-cursor", (data) ->
    console.log data
    IO.sockets.emit("tele-cursor", {value:data.value})

  socket.on "disconnect", () ->
    if userHash[socket.id]
      msg = userHash[socket.id] + "が退出しました"
      delete userHash[socket.id]
      IO.sockets.emit("tele-cursor", {value: msg})

# WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.
# WTH Random Walker.  WTH Random Walker.  WTH Random Walker.
