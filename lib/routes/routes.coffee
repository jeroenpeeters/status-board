Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'index',
      path: '/'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
    @route 'sunburst',
      path: '/sunburst'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
