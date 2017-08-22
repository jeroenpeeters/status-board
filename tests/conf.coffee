testx = require 'testx'
reporter = require 'testx-ictu-reporter'

exports.config =
  directConnect: true
  specs: ['spec/*']

  capabilities:
    browserName: 'chrome'
    shardTestFiles: false
    maxInstances: 2
    # chromeOptions:
    #   args: ['user-agent=Mozilla/5.0 (iPhone 8.0)']


  framework: 'jasmine'
  jasmineNodeOpts:
    silent: true
    defaultTimeoutInterval: 300000
    includeStackTrace: false

  baseUrl: process.env.appUrl
  rootElement: 'html' # change to the root element of the angular.js app

  params:
    testx:
      logScript: true
      actionTimeout: 4000

  onPrepare: ->
    testx.objects.add require './objects'
    testx.keywords.add require './keywords'

    reporter.addJasmineReporters()

    beforeEach -> browser.ignoreSynchronization = true
