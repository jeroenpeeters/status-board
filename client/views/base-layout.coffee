Template['base-layout'].helpers
  isDefaultMode: -> Session.get('mode') == 'default'

Template['base-layout'].rendered = ->
  $('body').on 'keydown', (e) ->
    if e?.which == 80 and e.target.nodeName == "BODY" # 'p' pressed
      if Session.get('mode') == 'default'
        Session.set 'mode', 'presenter'
      else
        Session.set 'mode', 'default'

Template['base-layout'].onCreated ->
  Meteor.call 'getGroups', (err, result) ->
    groups.set result
    visibleGroups.set result

Template.groupSelector.helpers
  groups: -> groups.get()
  groupActive: -> 'active' if @ in visibleGroups.get()
  glyphicon: -> if @ in visibleGroups.get() then 'eye-open' else 'eye-close'

Template.groupSelector.events
  'click .toggleGroup': (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @ in visibleGroups.get()
      visibleGroups.set _.without visibleGroups.get(), @
    else
      visibleGroups.set _.union visibleGroups.get(), [@]
