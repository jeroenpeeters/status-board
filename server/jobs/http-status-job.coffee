request = Meteor.npmRequire('hyperdirect')(10)

@HttpStatusJob =
  create: (name, group, url) ->
    Services.insert
      type: 'http'
      name: name
      group: group
      url: url

  update: (id, name, group, url) ->
    Services.update {_id: id}, $set:
      type: 'http'
      name: name
      group: group
      url: url

  remove: (id) ->
    Services.remove _id: id, ->
      ServiceStatus.remove serviceId: id

  job: (task, done) ->
    #console.log task.jobName, task.data
    @performCheck task, done, 0

  performCheck: (job, callback, retryCount) ->
    console.log 'check =>', job.data.url
    stream = request job.data.url,
      timeout: 10000

    stream.on 'error', Meteor.bindEnvironment (err) =>
      if retryCount > 2
        console.log "HTTP.Error #{job.data.url} =>", err
        FailJob job, callback
      else
        @retryJob job, callback, retryCount
    #stream.on 'data', (data) ->
    #  console.log "onData #{job.data.url} -> #{data}"

    stream.on 'response', Meteor.bindEnvironment (response) =>
      if response.statusCode >= 200 and response.statusCode < 300
        CompleteJob job, callback
      else
        if retryCount > 2
          console.log "HTTP.StatusCode err #{job.data.url} => #{response.statusCode}"
          FailJob job, callback
        else
          @retryJob job, callback, retryCount

  retryJob: (job, callback, retryCount) ->
    Meteor.setTimeout =>
      console.log 'retrying job', job.data.url
      @performCheck job, callback, retryCount+1
    , 2000
