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
  statusClass: -> if IsUp(@)  then 'dash-tile-green' else if IsDown(@) then 'dash-tile-red' else 'dash-tile-grey'
  statusText: -> if IsUp(@)  then 'Up' else if IsDown(@) then 'Down' else "Unknown"
  editRoute: editRoute
Template.tiles.onRendered ->

Template.table.helpers
  isDefaultMode: -> Session.get('mode') == 'default'
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusGlyphicon: -> if IsUp(@)  then 'ok-sign' else 'exclamation-sign'
  statusGlyphColor: -> if IsUp(@) then '#2ECC40' else '#FF4136'
  statusClass: -> StatusColorClass @#if IsUp(@)  then 'success' else 'danger'
  editRoute: editRoute

Template.simpleServiceStatusGraph.helpers
  statusColor: -> if IsUp(@)  then '#2ECC40' else '#FF4136'
  borderStatusColor: -> if IsUp(@) then 'green' else 'red'
  serviceStatus: ->
    Meteor.subscribe 'service/status', {name: @name}
    ServiceStatus.find {name: @name}, sort: date: -1
  dateFromNow: -> moment(@date).fromNow()
