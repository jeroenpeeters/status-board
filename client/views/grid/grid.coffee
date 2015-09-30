Template.grid.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  lastCheckHuman: -> moment(@lastCheck).fromNow()
  statusClass: -> console.log @; if @isUp then 'grid-green' else if !@isUp then 'grid-red' else 'grid-grey'
