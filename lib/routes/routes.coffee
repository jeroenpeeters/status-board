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
      path: '/view/sunburst'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
    @route 'tiles',
      path: '/view/tiles'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
    @route 'tables',
      path: '/view/tables'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
    @route 'grid',
      path: '/view/grid'
      subscriptions: -> [
        Meteor.subscribe 'services'
      ]
    @route 'service.details',
      template: 'service.details'
      path: '/service/details/:id'
      subscriptions: -> [
          Meteor.subscribe 'service', @params.id
          Meteor.subscribe 'service/status', {serviceId: @params.id}
        ]
      data: ->
        service: Services.findOne _id: @params.id
        history: ServiceStatus.find {serviceId: @params.id}, sort: 'status.date': -1
