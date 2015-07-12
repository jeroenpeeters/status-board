Template['new-ssh-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()

    console.log 'form submit new ssh'

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


    Meteor.call 'newSshService', e.target.serviceName.value, serviceDetails