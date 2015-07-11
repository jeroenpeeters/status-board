Template['new-http-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    Meteor.call 'newHttpService', e.target.serviceName.value, e.target.url.value