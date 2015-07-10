Template.index.helpers
  services: -> Services.find {}, sort: name: 1
  serviceStatus: ->
    Meteor.subscribe 'service/status', {name: @name}
    ServiceStatus.find {name: @name}, sort: date: -1
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if @isUp then 'dash-tile-green' else 'dash-tile-red'
  statusText: -> if @isUp then 'Up' else 'Down'
  statusColor: -> if @isUp then '#2ECC40' else '#FF4136'
  borderStatusColor: -> if @isUp then 'green' else 'red'

Template.index.onCreated ->
  Meteor.subscribe 'services'