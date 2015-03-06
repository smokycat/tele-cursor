$ ->
  socketio = io.connect('http://localhost:3000')

  start = (name) -> socketio.emit 'connected', name

  addMessage = (msg) ->
    $('body').prepend $("<div>#{msg.x} / #{msg.y}</div>")

  $('body').mousemove (event) ->
    tmp = "[#{myName}] position : #{event.pageX} , #{event.pageY}"
    socketio.emit 'tele-cursor', value: {
      x: event.pageX
      y: event.pageY
    }

  socketio.on 'connected', (name) ->
  socketio.on 'tele-cursor', (data) -> addMessage data.value
  socketio.on 'disconnect', ->
  myName = 'smokycat'
  start myName
