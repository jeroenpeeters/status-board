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
      ctx = {}
      ctx.statusCode = response.statusCode
      ctx.result = ''
      response.on 'data', (data) ->
        ctx.result = ctx.result + data.toString()
      response.on 'end', Meteor.bindEnvironment =>
        @executeChecks ctx
      response.on 'error',  Meteor.bindEnvironment =>
        @retryJobOrFail()

  executeChecks: (ctx) ->
    for check in @jobData.checks
      if not @[check.checkType](check, ctx)
        console.log "#{check.checkType} failed!"
        @markAsFailed()
        return
      else
        console.log "#{check.checkType} success!"
    @markAsCompleted()

  httpStatusCheck: (check, ctx) ->
    "#{ctx.statusCode}" == "#{check.statusCode}"

  httpRegexCheck: (check, ctx) ->
    if ctx.result
      ctx.result.match new RegExp(check.regex, 'i')
    else false
