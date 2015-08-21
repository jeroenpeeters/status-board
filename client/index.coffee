groups = new ReactiveVar null
visibleGroups = new ReactiveVar null

Template.index.helpers
  groups: -> visibleGroups.get()
  services: -> Services.find {group: @group}, sort: name: 1
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if @isUp then 'dash-tile-green' else 'dash-tile-red'
  statusText: -> if @isUp then 'Up' else 'Down'

Template.index.onCreated ->

  Meteor.call 'getGroups', (err, result) ->
    groups.set result
    visibleGroups.set result

Template.header.helpers
  groups: -> groups.get()
  groupActive: -> 'active' if @ in visibleGroups.get()

Template.header.events
  'click .toggleGroup': ->
    if @ in visibleGroups.get()
      visibleGroups.set _.without visibleGroups.get(), @
    else
      visibleGroups.set _.union visibleGroups.get(), [@]

Template.simpleServiceStatusGraph.helpers
  statusColor: -> if @isUp then '#2ECC40' else '#FF4136'
  borderStatusColor: -> if @isUp then 'green' else 'red'
  serviceStatus: ->
    Meteor.subscribe 'service/status', {name: @name}
    ServiceStatus.find {name: @name}, sort: date: -1
  dateFromNow: -> moment(@date).fromNow()
