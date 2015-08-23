ssh2 = Meteor.npmRequire 'ssh2-connect'

@SshJob =
  create: (collection, name, group, serviceDetails) ->
    console.log 'create new Ssh Job', name, group, serviceDetails
    job = new Job collection, 'sshJob',
      _.extend({ name: name, group: group }, serviceDetails)
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
          console.log err
          FailJob job
          session?.end()
          callback()
        else
          session.exec serviceDetails.cmd, Meteor.bindEnvironment (err, result) ->
            if err
              console.log err
              FailJob job
            else
              CompleteJob job

            session?.end()
            callback()
