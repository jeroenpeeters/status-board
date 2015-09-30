Template.grid.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> if @isUp then 'grid-green' else if @isDown then 'grid-red' else 'grid-grey'
