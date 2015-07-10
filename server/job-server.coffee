@FailJob = (jobData) ->
  jobData.lastCheck = new Date()
  jobData.isUp = false
  Services.upsert {name: jobData.name}, jobData
  ServiceStatus.insert
    name: jobData.name
    date: jobData.lastCheck
    isUp: jobData.isUp

@SucceedJob = (jobData) ->
  jobData.lastCheck = new Date()
  jobData.isUp = true
  Services.upsert {name: jobData.name}, jobData
  ServiceStatus.insert
    name: jobData.name
    date: jobData.lastCheck
    isUp: jobData.isUp

Meteor.startup ->
  JobsCollection  = JobCollection 'jobs'
  JobsCollection.remove {}

  ConfigureJobs JobsCollection

  HttpStatusJob.process JobsCollection
  SshJob.process JobsCollection

  JobsCollection.startJobServer()
