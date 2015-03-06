$ ->
  host = location.toString().split('/')[2]
  socketio = io.connect("http://#{host}")

  addMessage = (msg) ->
    $('body').prepend $("<div>#{JSON.stringify(msg)}</div>")

  $('html').mousemove (event) ->
    socketio.emit 'tele-cursor', [event.pageX, event.pageY]

  userTable = {}

  addUsers = (data) ->
    for key, val of data
      span = $ "<span>#{data[key].name}</span>"
      span.css "left", data[key].pos[0]
      span.css "top", data[key].pos[1]
      userTable[key] = span
      $("body").append span

  socketio.on 'connected', addUsers
  socketio.on 'welcome', addUsers

  socketio.on 'tele-cursor', (data) ->
    span = userTable[data[0]]
    span.css "left", data[1] - 16
    span.css "top", data[2] - 16
  socketio.on 'disconnect', (id) ->
    span = userTable[id]
    span.remove()
    delete userTable[id]

  # get parameterに名前「だけ」渡すこと。
  socketio.emit 'connected', location.toString().split('?')[1]
