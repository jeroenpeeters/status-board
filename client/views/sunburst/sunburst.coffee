Template.sunburst.onRendered ->
  Meteor.setTimeout ->
    Meteor.call 'getGroups', (err, result) ->

      createChildren = (name) ->
        console.log 'createChildren', name
        x = Services.find({'info.group': name}, sort: 'info.name': 1).fetch().map (item) ->
          name: item.info.name, group: item.info.group, isUp: item.isUp, size:1
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
