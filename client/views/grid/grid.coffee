Template.grid.helpers
  groups: -> visibleGroups.get()
  services: findServicesByGroup
  statusClass: -> StatusColorClass @
