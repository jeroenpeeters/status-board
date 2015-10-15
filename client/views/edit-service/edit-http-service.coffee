Template['edit-http-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    if @service
      Meteor.call 'updateHttpService', @service._id, e.target.serviceName.value, e.target.groupName.value, e.target.url.value
    else
      Meteor.call 'addHttpService', e.target.serviceName.value, e.target.groupName.value, e.target.url.value
