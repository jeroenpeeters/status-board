
@HttpStatusJob =
  create: (name, group, url) ->
    Services.upsert {name: name, type: 'http', group: group},
      type: 'http'
      name: name
      group: group
      url: url

  job: (task, done) ->
    console.log task.jobName, task.data
    @performCheck task, done, 0

  performCheck: (job, callback, retryCount) ->
    HTTP.get job.data.url, timeout: 2500, (err, data) =>
      if err or not data
        if retryCount > 2
          FailJob job, callback
        else
          @retryJob job, callback, retryCount
      else
        CompleteJob job, callback

  retryJob: (job, callback, retryCount) ->
    Meteor.setTimeout =>
      console.log 'retrying job', job.data.name
      @performCheck job, callback, retryCount+1
    , 2000
