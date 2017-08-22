class @StatusJob
  _retryJob: ->
    Meteor.setTimeout =>
      console.log 'retrying job', @
      @retryCount += 1
      @performCheck()
    , 2000

  retryJobOrFail: ->
    if @retryCount > 2
      console.log "Failing job", @
      @markAsFailed()
    else
      @_retryJob()

  markAsFailed: (err) ->
    date = new Date()
    status =
      'status.lastCheck': date
      'status.lastDownTime': date
      'status.isUp': false
    Services.update {_id: @jobData._id}, $set: status
    ServiceStatus.insert
      serviceId: @jobData._id
      status:
        date: date
        isUp: false
    @callback()

  markAsCompleted: (properties)->
    console.log 'properties!', properties
    status =
      'status.lastCheck': new Date()
      'status.isUp': true
      properties: properties
    Services.update {_id: @jobData._id}, $set: status
    ServiceStatus.insert
      serviceId: @jobData._id
      status:
        date: status['status.lastCheck']
        isUp: true
    @callback()

  executeChecks: (ctx) ->
    accumulator = {}
    storeProp = (name, value) ->
      accumulator[name] = value
    for check in @jobData.checks
      if not @[check.checkType]
       console.warn "Check #{check.checkType} not implemented!"
      else if not @[check.checkType](check, ctx, storeProp)
        console.log "Check #{check.checkType} failed!"
        @markAsFailed()
        return
      else
        console.log "Check #{check.checkType} success!"
    @markAsCompleted(accumulator)
