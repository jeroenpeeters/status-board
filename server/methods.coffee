Meteor.methods
  newHttpService: (name, url) ->
    HttpStatusJob.create JobsCollection, name, url

  newSshService: (name, serviceDetails) ->
    SshJob.create JobsCollection, name, serviceDetails