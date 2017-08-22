Meteor.startup ->

  Router.configure
    layoutTemplate: 'base-layout'

  Router.map ->
    @route 'service.http.create',
      template: 'edit-http-service'
      path: '/service/http/add'
      data: ->
        viewOnly: false
    @route 'service.http.edit',
      template: 'edit-http-service'
      path: '/service/http/edit/:id'
      waitOn: -> Meteor.subscribe 'service', @params.id
      data: ->
        service: Services.findOne _id: @params.id
        viewOnly: false

    @route 'service.ssh.create',
      template: 'edit-ssh-service'
      path: '/service/ssh/add'
      data: ->
        action: 'create'
        viewOnly: false
    @route 'service.ssh.edit',
      template: 'edit-ssh-service'
      path: '/service/ssh/edit/:id'
      waitOn: ->  Meteor.subscribe 'service', @params.id
      data: ->
        service: Services.findOne _id: @params.id
        viewOnly: false
