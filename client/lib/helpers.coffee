Session.set 'mode', 'default' if not Session.get 'mode'
@groups = new ReactiveVar null
@visibleGroups = new ReactiveVar null

@findServicesByGroup = -> Services.find {'info.group': @group}, sort: 'info.name': 1

@WasDownInLastHour = (service) ->
  service.status != undefined && service.status.lastDownTime != undefined &&
  moment().diff(service.status.lastDownTime, 'minutes') <= 60
@IsUp = (service) -> service.status != undefined and service.status.isUp
@IsDown = (service) -> service.status != undefined and service.status.isUp == false

@StatusColorClass = (service) ->
  if IsUp(service) and WasDownInLastHour(service)
    'status-down-in-last-hour'
  else if IsUp service
    'status-up'
  else if IsDown service
    'status-down'
  else
    'status-unknown'
