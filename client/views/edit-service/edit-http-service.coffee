Template['edit-http-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    if @service
      Meteor.call 'editHttpService', @service._id, e.target.serviceName.value, e.target.groupName.value, e.target.url.value
    else
      Meteor.call 'newHttpService', e.target.serviceName.value, e.target.groupName.value, e.target.url.value
  'click .btn-delete': ->
    Meteor.call 'removeHttpService', @service._id


Template['edit-http-service'].helpers
  isEditAction: -> @action == 'edit'
