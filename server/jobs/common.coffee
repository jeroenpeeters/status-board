@StatusJob =
  remove: (id) ->
    Services.remove _id: id, ->
      ServiceStatus.remove serviceId: id
