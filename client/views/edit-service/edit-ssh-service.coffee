Template['edit-ssh-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    serviceDetails =
      host: e.target.host.value
      port: e.target.port.value
      username: e.target.username.value
      cmd: e.target.cmd.value

    if e.target.password.value
      serviceDetails.password = e.target.password.value
    else if e.target.privateKeyPath.value
      serviceDetails.privateKeyPath = e.target.privateKeyPath.value
    else if e.target.privateKey.value
      serviceDetails.privateKey = e.target.privateKey.value

    if @service
      Meteor.call 'updateSshService', @service._id, e.target.serviceName.value, e.target.groupName.value, serviceDetails
    else
      Meteor.call 'addSshService', e.target.serviceName.value, e.target.groupName.value, serviceDetails
