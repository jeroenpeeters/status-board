
@HttpStatusJob =
  create: (collection, name, url) ->
    job = new Job collection, 'httpStatusJob',
      name: name
      url: url
    job.repeat
      repeats: collection.forever
      wait: 1000 * 60
    job.retry
      wait: 1000 * 60
    job.save()

  process: (collection) ->
    collection.processJobs 'httpStatusJob', (job, callback) ->
      console.log 'job running'
      HTTP.get job.data.url, timeout: 2500, (err, data) ->
        if err or not data
          FailJob job.data
          job.fail err.content
        else
          SucceedJob job.data
          job.done()
      callback()