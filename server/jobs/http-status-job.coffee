
@HttpStatusJob =
  create: (collection, name, group, url) ->
    job = new Job collection, 'httpStatusJob',
      name: name
      group: group
      url: url
    job.repeat
      repeats: collection.forever
      wait: 1000 * 60
    job.retry
      wait: 1000 * 60
    job.save()

  process: (collection) ->
    collection.processJobs 'httpStatusJob', {concurrency: 4, workTimeout: 5000}, (job, callback) =>
      console.log 'httpStatusJob', job.data.name
      #console.log 'job running', job
      @performCheck job, callback, 0

  performCheck: (job, callback, retryCount) ->
    job.progress retryCount, 100
    HTTP.get job.data.url, timeout: 2500, (err, data) =>
      if err or not data
        if retryCount > 3
          FailJob job, callback
        else
          @retryJob job, callback, retryCount
      else
        CompleteJob job, callback

  retryJob: (job, callback, retryCount) ->
    Meteor.setTimeout =>
      console.log 'retrying job', job.data.name
      @performCheck job, callback, retryCount+1
    , 1000
