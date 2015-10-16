selectedCheckType = new ReactiveVar null

Template['edit-http-service'].events
  'submit form': (e, tpl) ->
    e.preventDefault()
    jobData =
      name: e.target.serviceName.value
      group: e.target.groupName.value
      url: e.target.url.value
      regex: e.target.regex.value

    if @service
      Meteor.call 'updateHttpService', @service._id, jobData
    else
      Meteor.call 'addHttpService', jobData

Template.httpServiceChecks.helpers
  selectedCheckType: -> selectedCheckType.get()

Template.httpServiceChecks.events
  'change #checkType': (e) ->
    selectedCheckType.set e.currentTarget.value
