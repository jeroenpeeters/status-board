Template.navbar.helpers
  upCount: -> Services.find({isUp: true}).count()
  downCount: -> Services.find({isUp: false}).count()
  upNumberClass: ->
    if Services.find({isUp: true}).count() then 'up' else 'ok'
  downNumberClass: ->
    if Services.find({isUp: false}).count() then 'down' else 'ok'
