Template.tables.onRendered ->
  Meteor.setTimeout ->
    $('.masonry-grid').isotope
      itemSelector: 'table',
        masonry:
          columnWidth: 300
          gutter: 5
  , 500

Template.tables.helpers
  isDefaultMode: -> Session.get('mode') == 'default'
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusGlyphicon: -> if IsUp(@)  then 'ok-sign' else 'exclamation-sign'
  statusGlyphColor: -> if IsUp(@) then '#2ECC40' else '#FF4136'
  statusClass: ->
    mins = "#{@status.lastCheck.getMinutes()}"
    num = if mins.length > 1 then mins[1] else mins
    "#{StatusColorClass @} min-#{num}" #if IsUp(@)  then 'success' else 'danger'
  editRoute: -> "service.#{@type}.edit"
