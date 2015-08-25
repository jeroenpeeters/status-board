Meteor.methods

  getGroups: ->
    Services.aggregate($group: _id: "$group").map (item) -> group: item._id


  newHttpService: HttpStatusJob.create 

  newSshService: (name, group, serviceDetails) ->
    SshJob.create JobsCollection, name, group, serviceDetails
