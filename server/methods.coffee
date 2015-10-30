Meteor.methods

  getGroups: ->
    Services.aggregate($group: _id: "$info.group").map (item) -> group: item._id

  addHttpService: HttpStatusJobCrud.create
  updateHttpService: HttpStatusJobCrud.update
  addSshService: SshJob.create
  updateSshService: SshJob.update
  removeService: StatusJobCrud.remove
  addService: (serviceDetails) ->
    Services.insert serviceDetails
