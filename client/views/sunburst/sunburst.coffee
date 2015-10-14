Template.sunburst.onRendered ->
  Meteor.setTimeout ->
    Meteor.call 'getGroups', (err, result) ->

      console.log 'ww', Services.find({group: 'RAPP'}, sort: name: 1).fetch()

      createChildren = (name) ->
        console.log 'createChildren', name
        x = Services.find({group: name}, sort: name: 1).fetch().map (item) ->
          name: item.name, group: item.group, isUp: item.isUp, size:1
        console.log 'x',x
        x
      createNode = (name) -> {name: name, children: createChildren(name)}



      groups = (createNode group.group for group in result)
      console.log(groups);

      nodes =
        name: "root"
        children: groups

      sunbBurstComp nodes
  , 1000
