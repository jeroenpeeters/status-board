Meteor.methods
  newHttpService: (name, url) ->
    HttpStatusJob.create JobsCollection, name, url