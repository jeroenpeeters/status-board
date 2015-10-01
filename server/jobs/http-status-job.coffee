
@HttpStatusJob =
  create: (name, group, url) ->
    Services.upsert {name: name, type: 'http', group: group},
      type: 'http'
      name: name
      group: group
      url: url

  job: (task, done) ->
    #console.log task.jobName, task.data
    @performCheck task, done, 0

  performCheck: (job, callback, retryCount) ->
    console.log 'check =>', job.data.url
    options =
      timeout: 5000
      npmRequestOptions:
        agent: false
    HTTP.get job.data.url, options,  (err, data) =>
      if err or not data
        if retryCount > 2
          console.log err
          FailJob job, callback
        else
          @retryJob job, callback, retryCount
      else
        CompleteJob job, callback

  retryJob: (job, callback, retryCount) ->
    Meteor.setTimeout =>
      console.log 'retrying job', job.data.url
      @performCheck job, callback, retryCount+1
    , 2000
