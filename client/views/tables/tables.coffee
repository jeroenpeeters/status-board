Template.tables.onRendered ->
  console.log 'serial -> ', Session.get 'serial'
  $(".gridster").gridster
    widget_margins: [5, 5]
    widget_base_dimensions: [50, 30]
    widget_selector: 'table'
    helper: 'clone'
    draggable:
      stop: (event, ui) ->
        Session.set 'serial', @serialize()
    resize:
      enabled: true
      stop: (event, ui) ->
        Session.set 'serial', @serialize()
    serialize_params: (widget, wgd) ->
      id: widget.attr('id')
      col: wgd.col
      row: wgd.row
      size_x: wgd.size_x
      size_y: wgd.size_y

getPersistedSettingForGroup = (group, setting, functionToGetDefault) ->
  if Session.get 'serial'
    console.log group
    if item = Session.get('serial').filter((item) => item.id == group)[0]
      return item[setting]
  functionToGetDefault()

Template.tables.helpers
  sizey: -> getPersistedSettingForGroup @group, 'size_y', =>
    findServicesByGroup.bind(@)().count() + 1
  sizex: -> getPersistedSettingForGroup @group, 'size_x', -> 4
  col: -> getPersistedSettingForGroup @group, 'col', -> 1
  row: -> getPersistedSettingForGroup @group, 'row', -> 1
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
