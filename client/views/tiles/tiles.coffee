Template.tiles.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if IsUp(@)  then 'dash-tile-green' else if IsDown(@) then 'dash-tile-red' else 'dash-tile-grey'
  statusText: -> if IsUp(@)  then 'Up' else if IsDown(@) then 'Down' else "Unknown"
  editRoute: -> "service.#{@type}.edit"
  bla: -> console.log '!!', @; []
  properties: -> Object.keys(@properties or {}).map (k, idx, val) =>
    name: k
    value: @properties[k]
  isAdmin: (x) -> not x.viewOnly
