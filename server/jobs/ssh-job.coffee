ssh2 = Meteor.npmRequire 'ssh2-connect'

@SshJob =
  create: (collection, name, server, username, privateKeyPath, cmd) ->
    job = new Job collection, 'sshJob',
      name: name
      server: server
      username: username
      privateKeyPath: privateKeyPath
      cmd: cmd
    job.repeat
      repeats: collection.forever
      wait: 1000 * 60
    job.retry
      wait: 1000 * 60
    job.save()

  process: (collection) ->
    collection.processJobs 'sshJob', (job, callback) ->
      ssh2 host: job.data.server, username: job.data.username, privateKeyPath: job.data.privateKeyPath, readyTimeout:2500, Meteor.bindEnvironment (err, session) ->
        if err
          console.log err
          FailJob job.data
          job.fail err.content
          callback()
        else
          session.exec job.data.cmd, Meteor.bindEnvironment (err, result) ->
            if err
              console.log err
              FailJob job.data
              job.fail err.content
            else
              SucceedJob job.data
              job.done()
            callback()