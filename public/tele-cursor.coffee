$ ->
  host = location.toString().split('/')[2]
  socketio = io.connect("http://#{host}")

  addMessage = (msg) ->
    $('body').prepend $("<div>#{JSON.stringify(msg)}</div>")

  $('html').mousemove (event) ->
    socketio.emit 'tele-cursor', [event.pageX, event.pageY]

  socketio.on 'connected', (data) -> console.log JSON.stringify data
  socketio.on 'tele-cursor', (data) -> console.log JSON.stringify data
  socketio.on 'disconnect', (id) -> console.log id

  # get parameterに名前「だけ」渡すこと。
  socketio.emit 'connected', location.toString().split('?')[1]
