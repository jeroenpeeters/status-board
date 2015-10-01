Template.grid.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if IsUp(@) then 'grid-green' else if IsDown(@) then 'grid-red' else 'grid-grey'
