@FailJob = (job, err) ->
  jobData = job.data
  jobData.lastCheck = new Date()
  jobData.isUp = false
  if job._doc.retried > 1 # ensures that we only mark a service as failed after two attempts
    Services.upsert {name: jobData.name}, jobData
    ServiceStatus.insert
      name: jobData.name
      date: jobData.lastCheck
      isUp: jobData.isUp
  job.fail()

@CompleteJob = (job) ->
  jobData = job.data
  jobData.lastCheck = new Date()
  jobData.isUp = true
  Services.upsert {name: jobData.name}, jobData
  ServiceStatus.insert
    name: jobData.name
    date: jobData.lastCheck
    isUp: jobData.isUp
  job.done()

@JobsCollection  = JobCollection 'jobs'

Meteor.startup ->

  #JobsCollection.remove {}
  #ConfigureJobs JobsCollection

  HttpStatusJob.process JobsCollection
  SshJob.process JobsCollection

  JobsCollection.startJobServer()
