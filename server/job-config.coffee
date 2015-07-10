@ConfigureJobs = (JobsCollection) ->
  HttpStatusJob.create JobsCollection, 'Google', 'http://www.google.com/'
  HttpStatusJob.create JobsCollection, 'Yahoo', 'http://www.yahoo.com/'
  HttpStatusJob.create JobsCollection, 'JeroenPeeters.nl', 'http://www.jeroenpeeters.nl/'


  #SshJob.create JobsCollection, 'SomeServer', '10.19.88.21', 'core', '~/.ssh/id_rsa', 'ls'