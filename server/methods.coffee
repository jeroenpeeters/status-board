Meteor.methods

  getGroups: ->
    Services.aggregate($group: _id: "$info.group").map (item) -> group: item._id

  removeService: (id) ->
    Services.remove _id: id, ->
      ServiceStatus.remove serviceId: id
  updateService: (id, serviceDetails) ->
    Services.update {_id: id}, $set: serviceDetails
  addService: (serviceDetails) ->
    console.log 'addService', serviceDetails
    Services.insert serviceDetails
