Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'service.http.create',
      template: 'new-http-service'
      path: '/service/http/create'
      data: -> action: 'create'
    @route 'service.http.edit',
      template: 'new-http-service'
      path: '/service/http/edit/:id'
      subscriptions: -> Meteor.subscribe 'service', @params.id
      data: ->
        service: Services.findOne _id: @params.id
        action: 'edit'

    @route 'service.ssh.create',
      template: 'new-ssh-service'
      path: '/service/ssh/create'
      data: -> action: 'create'
    @route 'service.ssh.edit',
      template: 'new-ssh-service'
      path: '/service/ssh/edit/:id'
      subscriptions: ->  Meteor.subscribe 'service', @params.id
      data: ->
        service: Services.findOne _id: @params.id
        action: 'edit'
