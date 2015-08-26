Meteor.startup ->
  Meteor.publish 'service', (id) -> Services.find _id: id
  Meteor.publish 'services', -> Services.find()
  Meteor.publish 'service/status', (service) -> ServiceStatus.find service, limit: 100, sort: {date: -1}
  Meteor.publish 'jobs/status', (job) -> ServiceStatus.find name: job.data.name, limit: 100, sort: {date: -1}
  Meteor.publish 'jobs', -> JobsCollection.find({})
