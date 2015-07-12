ssh2 = Meteor.npmRequire 'ssh2-connect'

@SshJob =
  create: (collection, name, serviceDetails) ->
    console.log 'create new Ssh Job', name, serviceDetails
    job = new Job collection, 'sshJob',
      _.extend({ name: name }, serviceDetails)
    job.repeat
      repeats: collection.forever
      wait: 1000 * 60
    job.retry
      wait: 1000 * 60
    job.save()

  process: (collection) ->
    collection.processJobs 'sshJob', (job, callback) ->
      serviceDetails = _.extend {readyTimeout:2500}, job.data
      ssh2 serviceDetails, Meteor.bindEnvironment (err, session) ->
        if err
          FailJob job
          callback()
        else
          session.exec serviceDetails.cmd, Meteor.bindEnvironment (err, result) ->
            if err
              FailJob job
            else
              CompleteJob job
            callback()