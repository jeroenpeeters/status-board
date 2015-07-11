Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'index',
      path: '/'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
