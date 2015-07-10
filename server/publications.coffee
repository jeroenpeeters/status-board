Meteor.publish 'services', -> Services.find()
Meteor.publish 'service/status', (service) -> ServiceStatus.find service, limit: 100, sort: {date: -1}