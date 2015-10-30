
constructSpec = (e) ->
  spec =
    host: e.target.host.value
    port: e.target.port.value
    username: e.target.username.value
    cmd: e.target.cmd.value
  if e.target.password.value
    spec.password = e.target.password.value
  else if e.target.privateKeyPath.value
    spec.privateKeyPath = e.target.privateKeyPath.value
  else if e.target.privateKey.value
    spec.privateKey = e.target.privateKey.value
  spec

Template['edit-ssh-service'].helpers
  service: -> @service or {}

Template['edit-ssh-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    jobData =
      type: 'ssh'
      info:
        name: e.target.serviceName.value
        group: e.target.groupName.value
      spec: constructSpec e
      checks: []

    if @service
      Meteor.call 'updateService', @service._id, jobData
      #Meteor.call 'updateSshService', @service._id, e.target.serviceName.value, e.target.groupName.value, serviceDetails
    else
       Meteor.call 'addService', jobData
      #Meteor.call 'addSshService', e.target.serviceName.value, e.target.groupName.value, serviceDetails
