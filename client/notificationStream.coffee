Meteor.startup ->

  # sAlert.config
  #   effect: 'slide'
  #   position: 'top-right'
  #   timeout: 5000
  #   html: true
  #   onRouteClose: false
  #   stack: true
  #   offset: 20

  notificationStream = new Meteor.Stream 'notificationStream'
  notificationStream.on 'alarm', (message) ->
    sirenId = Random.choice ['#siren1', '#siren2']
    $(sirenId)?.get(0)?.play()
