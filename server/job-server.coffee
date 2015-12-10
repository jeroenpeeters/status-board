@JobsCollection  = JobCollection 'jobs'

Meteor.startup ->

  # processors =
  #   http: HttpStatusJob
  #   ssh: SshJob
  #
  jobFactory =
    http: (task, doneCallback) -> new HttpStatusJob task.data, doneCallback
    ssh:  (task, doneCallback) -> new SshStatusJob task.data, doneCallback

  for type of jobFactory #when processors[p].job
    Cue.addJob "#{type}", {retryOnError:false, maxMs:30000}, jobFactory[type] #processors[p].job.bind(processors[p])

  Cue.maxTasksAtOnce = 8
  Cue.dropTasks()
  Cue.dropInProgressTasks()
  Cue.start()

  scheduleChecks = ->
    console.log 'Looking for services to check'
    Services.find().fetch().forEach (service) ->
      if jobFactory[service.type]
        Cue.addTask service.type, {isAsync:true, unique:true}, service
      else
        console.error 'No processors for service', service

  Meteor.setInterval scheduleChecks, 60000

  scheduleChecks() # perform initial checks
