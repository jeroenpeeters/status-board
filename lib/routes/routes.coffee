Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'index',
      path: '/'
      waitOn: -> [
        Meteor.subscribe 'services'
      ]
    @route 'sunburst',
      path: '/view/sunburst'
      waitOn: -> [
        Meteor.subscribe 'services'
      ]
    @route 'tiles',
      path: '/view/tiles'
      waitOn: -> [
        Meteor.subscribe 'services'
      ]
    @route 'tables',
      path: '/view/tables'
      waitOn: -> [
        Meteor.subscribe 'services'
      ]
    @route 'grid',
      path: '/view/grid'
      waitOn: -> [
        Meteor.subscribe 'services'
      ]
    @route 'service.details',
      template: 'service.details'
      path: '/service/details/:id'
      waitOn: -> [
          Meteor.subscribe 'service', @params.id
          Meteor.subscribe 'service/status', {serviceId: @params.id}
        ]
      data: ->
        service: Services.findOne _id: @params.id
        history: ServiceStatus.find {serviceId: @params.id}, sort: 'status.date': -1
