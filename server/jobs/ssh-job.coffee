ssh2 = Meteor.npmRequire 'ssh2-connect'

@SshJob =
  create: (name, group, serviceDetails) ->
    Services.insert _.extend({ name: name, type: 'ssh', group: group }, serviceDetails)

  update: (id, name, group, serviceDetails) ->
    Services.update {_id: id}, _.extend({ name: name, type: 'ssh', group: group }, serviceDetails)

  job: (task, done) -> @performCheck task, done, 0

  performCheck: (job, callback, retryCount) ->
    serviceDetails = _.extend {readyTimeout:2500}, job.data
    ssh2 serviceDetails, Meteor.bindEnvironment (err, session) ->
      if err
        console.log err
        if retryCount > 3
          FailJob job, callback
          session?.end()
        else SshJob.retryJob job, callback, retryCount
      else
        session.exec serviceDetails.cmd, Meteor.bindEnvironment (err, stream) ->
          if err
            console.error err
            if retryCount > 2
              FailJob job, callback
              session?.end()
            else
              SshJob.retryJob job, callback, retryCount
          else
            if job.data.regex
              result = ""
              stream.on 'data', (data) ->
                result = result + data.toString()
              stream.on 'close', Meteor.bindEnvironment =>
                if result.match new RegExp(job.data.regex, 'i')
                  CompleteJob job, callback
                else
                  FailJob job, callback
                session?.end()
            else
              CompleteJob job, callback
              session?.end()

  retryJob: (job, callback, retryCount) ->
    Meteor.setTimeout =>
      console.log 'retrying ssh job'
      @performCheck job, callback, retryCount+1
    , 2000
