Template.sunburst.onRendered ->

  Meteor.call 'getGroups', (err, result) ->

    createChildren = (name) ->
      console.log 'createChildren', name
      x = Services.find({group: name}, sort: name: 1).fetch().map ((item) -> name: item.name, size:1)
      console.log x
      x
    createNode = (name) -> {name: name, children: createChildren(name)}



    groups = (createNode group.group for group in result)
    console.log(groups);

    nodes =
      name: "root"
      children: groups

    sunbBurstComp nodes
