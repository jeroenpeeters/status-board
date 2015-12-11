request = Meteor.npmRequire('hyperdirect')(10)

class @HttpStatusJob extends StatusJob
  constructor: (@jobData, @callback, @retryCount = 0) ->
    @performCheck()

  performCheck: ->
    console.log 'http', @jobData
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

  httpStatusCheck: (check, ctx) ->
    "#{ctx.statusCode}" == "#{check.statusCode}"

  httpRegexCheck: (check, ctx) ->
    if ctx.result
      ctx.result.match new RegExp(check.regex, 'i')
    else false
