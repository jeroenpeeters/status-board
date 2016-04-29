Meteor.startup ->
  console.log 'xxx', @WebApp
  sio = Meteor.npmRequire 'socket.io'
  socketIO = sio.listen @WebApp.httpServer
  console.log 'wieee', socketIO
  console.log 'woo', @WebApp.httpServer

  # socketIO.configure ->
  #   socketIO.set 'log level', 0
  #   socketIO.set 'authorization', (handshakeData, callback) ->
  #     callback null, true

  # socketIO.set "transports", ["xhr-polling"]
  # socketIO.set "polling duration", 30

  socketIO.on 'connection', Meteor.bindEnvironment (client) =>
    console.log "#{client.id} is connected"
    handle = Services.find().observe
      changed: (newDoc, oldDoc) ->
        # console.log 'send to client ', newDoc
        client.emit 'service', newDoc
    client.on 'disconnect', ->
      console.log "#{client.id} is disconnected"
      handle.stop()
    client.on 'example', (msg) ->
      console.log 'received', msg
      client.emit 'example', parseInt(msg) + 1
