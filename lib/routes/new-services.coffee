Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'new-http-service',
      template: 'new-http-service'
      path: '/service/http/create'

    @route 'new-ssh-service',
      template: 'new-ssh-service'
      path: '/service/ssh/create'