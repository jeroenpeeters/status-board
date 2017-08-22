ssh2 = Meteor.npmRequire 'ssh2-connect'

class @SshStatusJob extends StatusJob
  constructor: (@jobData, @callback, @retryCount = 0) ->
    @performCheck()

  performCheck: ->
    console.log 'ssh-perform', @jobData
    serviceSpec = _.extend {readyTimeout:2500}, @jobData.spec
    ssh2 serviceSpec, Meteor.bindEnvironment (err, session) =>
      if err
        @retryJobOrFail()
        session?.end()
      else
        session.exec serviceSpec.cmd, Meteor.bindEnvironment (err, result) =>
          if err then @retryJobOrFail()
          else
            @markAsCompleted()
          session?.end()
