Meteor.methods

  getGroups: ->
    Services.aggregate($group: _id: "$group").map (item) -> group: item._id


  newHttpService: (name, group, url) ->
    HttpStatusJob.create JobsCollection, name, group, url

  newSshService: (name, group, serviceDetails) ->
    SshJob.create JobsCollection, name, group, serviceDetails
