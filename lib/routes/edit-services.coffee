Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'service.http.create',
      template: 'edit-http-service'
      path: '/service/http/add'
      data: -> action: 'create'
    @route 'service.http.edit',
      template: 'edit-http-service'
      path: '/service/http/edit/:id'
      subscriptions: -> Meteor.subscribe 'service', @params.id
      data: ->
        service: Services.findOne _id: @params.id
        action: 'edit'

    @route 'service.ssh.create',
      template: 'edit-ssh-service'
      path: '/service/ssh/add'
      data: -> action: 'create'
    @route 'service.ssh.edit',
      template: 'edit-ssh-service'
      path: '/service/ssh/edit/:id'
      subscriptions: ->  Meteor.subscribe 'service', @params.id
      data: ->
        service: Services.findOne _id: @params.id
        action: 'edit'
