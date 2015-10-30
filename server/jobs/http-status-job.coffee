request = Meteor.npmRequire('hyperdirect')(10)

@HttpStatusJobCrud = _.extend
  create: (jobData) ->
    Services.insert _.extend(jobData, {type: 'http'})
  update: (id, jobData) ->
    Services.update {_id: id}, $set: jobData
, StatusJobCrud


class @HttpStatusJob extends StatusJob
  constructor: (@jobData, @callback, @retryCount = 0) ->
    console.log 'constructed HttpStatusJob', @
    @performCheck()

  performCheck: ->
    stream = request @jobData.spec.url,
      timeout: 10000

    stream.on 'error', Meteor.bindEnvironment (err) =>
      @retryJobOrFail()

    stream.on 'response', Meteor.bindEnvironment (response) =>
      if response.statusCode >= 200 and response.statusCode < 300
        if @jobData.regex
          result = ""
          response.on 'data', (data) -> result = result + data.toString()
          response.on 'end', Meteor.bindEnvironment =>
            if result.match new RegExp(job.data.regex, 'i')
              @markAsCompleted()
            else
              @markAsFailed()
        else
          @markAsCompleted()
      else
        @retryJobOrFail()

  # executeChecks: (checks, response, body) ->
  #   for check in checks
  #     if not @[check.checkType](check, response, body) then
  #       FailJob job, callback
  #
  # httpStatusCheck: (check, response) ->
  #   "#{response.statusCode}" == "#{check.statusCode}"
