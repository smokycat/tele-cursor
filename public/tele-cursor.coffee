$ ->
  socketio = io.connect('http://localhost:3000')

  start = (name) -> socketio.emit 'connected', name

  addMessage = (msg) ->
    $('body').prepend $("<div>#{JSON.stringify(msg)}</div>")

  $('html').mousemove (event) ->
    socketio.emit 'tele-cursor', [event.pageX, event.pageY]

  socketio.on 'connected', (name) -> console.log name
  socketio.on 'tele-cursor', (data) -> console.log JSON.stringify data
  socketio.on 'disconnect', (name) -> console.log name
  myName = 'smokycat'
  start myName
