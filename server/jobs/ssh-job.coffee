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
    collection.processJobs 'sshJob', {concurrency: 10}, (job, callback) =>
      @performCheck job, callback, 0

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
            if retryCount > 3
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
    , 5000
