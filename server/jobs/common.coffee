class @StatusJob
  constructor: (@id) ->
  remove: ->
    Services.remove _id: @id, ->
      ServiceStatus.remove serviceId: @id
