@FailJob = (job, callback, err) ->
  jobData = job.data
  date = new Date()
  status =
    lastCheck: date
    lastDownTime: date
    isUp: false
  Services.update {name: jobData.name, type: jobData.type, group: jobData.group}, $set: status
  ServiceStatus.insert
    serviceId: jobData._id
    date: jobData.lastCheck
    isUp: jobData.isUp
  callback()

@CompleteJob = (job, callback) ->
  jobData = job.data
  status =
    lastCheck: new Date()
    isUp: true
  Services.update {name: jobData.name, type: jobData.type, group: jobData.group}, $set: status
  ServiceStatus.insert
    serviceId: jobData._id
    date: jobData.lastCheck
    isUp: jobData.isUp
  callback()

@JobsCollection  = JobCollection 'jobs'

Meteor.startup ->

  processors =
    http: HttpStatusJob
    ssh: SshJob

  for p of processors when processors[p].job
    Cue.addJob "#{p}", {retryOnError:false, maxMs:30000}, processors[p].job.bind(processors[p])

  Cue.maxTasksAtOnce = 8
  Cue.dropTasks()
  Cue.dropInProgressTasks()
  Cue.start()

  scheduleChecks = ->
    console.log 'Looking for services to check'
    Services.find().fetch().forEach (service) ->
      if processors[service.type]
        Cue.addTask service.type, {isAsync:true, unique:true}, service
      else
        console.error 'No processors for service', service

  Meteor.setInterval scheduleChecks, 60000

  scheduleChecks() # perform initial checks
