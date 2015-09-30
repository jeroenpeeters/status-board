editRoute = -> "service.#{@type}.edit"

Template.index.helpers
  showAs: (type) -> Session.get('displayType') == type
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
  activeWhenShowAsGrid: -> 'active' if Session.get('displayType') == 'grid'

Template.header.events
  'click .toggleGroup': ->
    if @ in visibleGroups.get()
      visibleGroups.set _.without visibleGroups.get(), @
    else
      visibleGroups.set _.union visibleGroups.get(), [@]
  'click #showAsTiles': -> Session.set 'displayType', 'tiles'
  'click #showAsTable': -> Session.set 'displayType', 'table'
  'click #showAsGrid': -> Session.set 'displayType', 'grid'

Template.tiles.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if @isUp then 'dash-tile-green' else if !@isUp then 'dash-tile-red' else 'dash-tile-grey'
  statusText: -> if @isUp then 'Up' else if !@isUp then 'Down' else "Unknown"
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
