Template.submitButtons.events
  'click .btn-delete': ->
    Meteor.call 'removeService', @service._id
