Template['base-layout'].helpers
  isDefaultMode: -> Session.get('mode') == 'default'

Template['base-layout'].rendered = ->
  $('body').on 'keydown', (e) ->
    if e?.which == 80 and e.target.nodeName == "BODY" # 'p' pressed
      if Session.get('mode') == 'default'
        Session.set 'mode', 'presenter'
      else
        Session.set 'mode', 'default'
