
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
    collection.processJobs 'httpStatusJob', (job, callback) ->
      console.log 'job running', job
      HTTP.get job.data.url, timeout: 2500, (err, data) ->
        if err or not data
          FailJob job
        else
          CompleteJob job
      callback()
