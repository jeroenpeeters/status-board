Session.set 'displayType', 'tiles'
Session.set 'mode', 'default'
groups = new ReactiveVar null
visibleGroups = new ReactiveVar null


findServicesByGroup = -> Services.find {group: @group}, sort: name: 1
editRoute = -> "service.#{@type}.edit"

Template.index.helpers
  showAsTiles: -> Session.get('displayType') == 'tiles'
  isDefaultMode: -> Session.get('mode') == 'default'

Template.index.onCreated ->
  Meteor.call 'getGroups', (err, result) ->
    groups.set result
    visibleGroups.set result

Template.header.helpers
  groups: -> groups.get()
  groupActive: -> 'active' if @ in visibleGroups.get()
  activeWhenShowAsTiles: -> 'active' if Session.get('displayType') == 'tiles'
  activeWhenShowAsTable: -> 'active' if Session.get('displayType') == 'table'

Template.header.events
  'click .toggleGroup': ->
    if @ in visibleGroups.get()
      visibleGroups.set _.without visibleGroups.get(), @
    else
      visibleGroups.set _.union visibleGroups.get(), [@]
  'click #showAsTiles': -> Session.set 'displayType', 'tiles'
  'click #showAsTable': -> Session.set 'displayType', 'table'

Template.tiles.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if @isUp then 'dash-tile-green' else if @isDown then 'dash-tile-red' else 'dash-tile-grey'
  statusText: -> if @isUp then 'Up' else if @isDown then 'Down' else "Unknown"
  editRoute: editRoute
Template.table.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusGlyphicon: -> if @isUp then 'ok-sign' else 'exclamation-sign'
  statusGlyphColor: -> if @isUp then '#2ECC40' else '#FF4136'
  statusClass: -> if @isUp then 'success' else 'danger'
  editRoute: editRoute

Template.simpleServiceStatusGraph.helpers
  statusColor: -> if @isUp then '#2ECC40' else '#FF4136'
  borderStatusColor: -> if @isUp then 'green' else 'red'
  serviceStatus: ->
    Meteor.subscribe 'service/status', {name: @name}
    ServiceStatus.find {name: @name}, sort: date: -1
  dateFromNow: -> moment(@date).fromNow()
