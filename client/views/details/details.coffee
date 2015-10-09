Template['service.details'].helpers
  lastCheckFromNow: -> moment(@lastCheck).fromNow()
  lastDownTimeFromNow: -> moment(@lastDownTime).fromNow()

Template.simpleServiceStatusGraph.helpers
  statusColor: -> if IsUp(@)  then '#2ECC40' else '#FF4136'
  borderStatusColor: -> if IsUp(@) then 'green' else 'red'
  dateFromNow: -> moment(@date).fromNow()
