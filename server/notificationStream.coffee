notificationStream = new Meteor.Stream 'notificationStream'

notificationStream.permissions.write -> false
notificationStream.permissions.read -> true


Services.find().observeChanges
  changed: (id, fields) ->
    if fields.isUp != undefined and fields.isUp == false
      notificationStream.emit 'alarm', {serviceId: id}
