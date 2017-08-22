module.exports =
  "homePageTitle":
    locator: "css"
    value: "p"

  'inputWithId': (id) ->
    locator: 'css'
    value: "input##{id}"

  'submitButton':
    locator: 'css'
    value: "button[type='submit']"

  'groupName':
    locator: 'css'
    value: 'h3.group-name'

  'tileText':
    locator: 'css'
    value: 'div.dash-tile-text'
