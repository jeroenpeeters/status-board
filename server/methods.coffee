Meteor.methods

  getGroups: ->
    Services.aggregate($group: _id: "$info.group").map (item) -> group: item._id

  updateHttpService: HttpStatusJobCrud.update
  updateSshService: SshJob.update
  removeService: StatusJobCrud.remove
  updateService: (id, serviceDetails) ->
    Services.update {_id: id}, $set: serviceDetails
  addService: (serviceDetails) ->
    Services.insert serviceDetails
