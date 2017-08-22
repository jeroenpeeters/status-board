checksTemplate =
  checkType: 'httpStatusCheck'
  statusCode: '200'
checks = new ReactiveVar [checksTemplate]
dataRetrieval = new ReactiveVar []

Template['edit-http-service'].onCreated ->
  if _checks = Template.currentData()?.service?.checks
    checks.set _checks

Template['edit-http-service'].onRendered ->
  $('#tags').tagsinput()
  $('.bootstrap-tagsinput').addClass 'form-control'

Template['edit-http-service'].helpers
  service: -> @service or {}

Template['edit-http-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    jobData =
      type: 'http'
      info:
        name: e.target.serviceName.value
        group: e.target.groupName.value
        tags: e.target.tags.value.split ','
      spec:
        url: e.target.url.value
        basicAuth: e.target.basicAuth.value
      checks: []

    console.log jobData

    tpl.$('.statusCheck').each (index, node) ->
      item = tpl.$ node
      checkType = item.data 'check-type'
      check = checkType: checkType
      $('input', item).each (_index, inputNode) ->
        inputItem = $ inputNode, item
        check[inputItem.attr 'name'] = inputItem.val()
      jobData.checks.push check

    if @service
      Meteor.call 'updateService', @service._id, jobData
    else
      Meteor.call 'addService', jobData

Template.httpServiceChecks.helpers
  checks: -> checks.get()

Template.httpServiceChecks.events
  'click a': (e) ->
    checkType = $(e.currentTarget).data 'check-type'
    _checks = checks.get()
    _checks.push checkType: checkType
    checks.set _checks

Template.dataRetrieval.helpers
  dataRetrieval: -> dataRetrieval.get()

Template.dataRetrieval.events
  'click a': (e) ->
    _dataRetrieval = dataRetrieval.get()
    _dataRetrieval.push type: $(e.currentTarget).data 'type'
    dataRetrieval.set _dataRetrieval
