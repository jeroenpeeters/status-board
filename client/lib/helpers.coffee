Session.set 'displayType', 'tiles' if not Session.get 'displayType'
Session.set 'mode', 'default' if not Session.get 'mode'

@groups = new ReactiveVar null
@visibleGroups = new ReactiveVar null

@findServicesByGroup = -> Services.find {group: @group}, sort: name: 1

@WasDownInLastHour = (service) ->
  service.lastDownTime != undefined && moment().diff(service.lastDownTime, 'minutes') <= 60
@IsUp = (service) -> service.isUp
@IsDown = (service) -> service.isUp == false and service.isUp != undefined

@StatusColorClass = (service) ->
  if IsUp(service) and WasDownInLastHour(service)
    'status-down-in-last-hour'
  else if IsUp service
    'status-up'
  else if IsDown service
    'status-down'
  else
    'status-unknown'
