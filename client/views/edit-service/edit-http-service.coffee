Template['edit-http-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    Meteor.call 'newHttpService', e.target.serviceName.value, e.target.groupName.value, e.target.url.value

Template['edit-http-service'].helpers
  isEditAction: -> @action == 'edit'
