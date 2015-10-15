ssh2 = Meteor.npmRequire 'ssh2-connect'

@SshJob =
  create: (name, group, serviceDetails) ->
    Services.insert _.extend({ name: name, type: 'ssh', group: group }, serviceDetails)

  update: (id, name, group, serviceDetails) ->
    Services.update {_id: id}, _.extend({ name: name, type: 'ssh', group: group }, serviceDetails)

  job: (task, done) ->
    console.log task.jobName, task.data
    @performCheck task, done, 0

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
        session.exec serviceDetails.cmd, Meteor.bindEnvironment (err, result) ->
          if err
            console.log err
            if retryCount > 2
              FailJob job, callback
            else
              SshJob.retryJob job, callback, retryCount
          else
            CompleteJob job, callback

          session?.end()

  retryJob: (job, callback, retryCount) ->
    Meteor.setTimeout =>
      console.log 'retrying ssh job'
      @performCheck job, callback, retryCount+1
    , 2000
