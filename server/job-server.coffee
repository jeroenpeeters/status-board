@FailJob = (job, callback, err) ->
  jobData = job.data
  jobData.lastCheck = new Date()
  jobData.isUp = false
  Services.upsert {name: jobData.name, type: jobData.type, group: jobData.group}, jobData
  ServiceStatus.insert
    name: jobData.name
    group: jobData.group
    date: jobData.lastCheck
    isUp: jobData.isUp
  callback()

@CompleteJob = (job, callback) ->
  jobData = job.data
  jobData.lastCheck = new Date()
  jobData.isUp = true
  Services.upsert {name: jobData.name, type: jobData.type, group: jobData.group}, jobData
  ServiceStatus.insert
    name: jobData.name
    date: jobData.lastCheck
    isUp: jobData.isUp
  callback()

@JobsCollection  = JobCollection 'jobs'

Meteor.startup ->

  processors =
    http: HttpStatusJob
    ssh: SshJob

  for p of processors when processors[p].job
    x = (p) ->
      console.log "p=#{p}"
      Cue.addJob "#{p}", {retryOnError:false, maxMs:30000}, (task, done) -> console.log "run p=#{p}"; processors[p].job task, done
    x p

  Cue.dropTasks()
  Cue.dropInProgressTasks()
  Cue.start()

  scheduleChecks = ->
    console.log 'Looking for services to check'
    Services.find().fetch().forEach (service) ->
      if processors[service.type]
        console.log 'scheduling for type', service.type
        Cue.addTask service.type, {isAsync:true, unique:false}, service
      else
        console.error 'No processors for service', service

  Meteor.setInterval scheduleChecks, 60000

  scheduleChecks() # perform initial checks
