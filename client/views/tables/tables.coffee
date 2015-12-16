Template.tables.onRendered ->
  Meteor.setTimeout ->
    $(".gridster").gridster
      widget_margins: [5, 5]
      widget_base_dimensions: [50, 30]
      widget_selector: 'table'
      resize: enabled: true
      helper: 'clone'
      draggable: stop: (event, ui) ->
        console.log @serialize()
      # resize:
      #   stop: (event, ui) ->
      #     console.log @serialize()
      #   handle_append_to: false
  , 500

Template.tables.helpers
  sizey: ->findServicesByGroup.bind(@)().count() + 1
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
