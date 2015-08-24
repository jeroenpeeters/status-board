@FailJob = (job, callback, err) ->
  jobData = job.data
  jobData.lastCheck = new Date()
  jobData.isUp = false
  Services.upsert {name: jobData.name, group: jobData.group}, jobData
  ServiceStatus.insert
    name: jobData.name
    group: jobData.group
    date: jobData.lastCheck
    isUp: jobData.isUp
  job.fail()
  callback()

@CompleteJob = (job, callback) ->
  jobData = job.data
  jobData.lastCheck = new Date()
  jobData.isUp = true
  Services.upsert {name: jobData.name}, jobData
  ServiceStatus.insert
    name: jobData.name
    date: jobData.lastCheck
    isUp: jobData.isUp
  job.done()
  callback()

@JobsCollection  = JobCollection 'jobs'

Meteor.startup ->

  staleJobsIds = JobsCollection.find(status: "running").map (job) -> job._id
  console.log staleJobsIds
  JobsCollection.getJobs staleJobsIds, (error, jobs) ->
    jobs.forEach (job) ->
      #console.log job
      job.save()
      job.repeat() # re-saving reschedules these stale jobs in the queue


  HttpStatusJob.process JobsCollection
  SshJob.process JobsCollection

  JobsCollection.startJobServer()
