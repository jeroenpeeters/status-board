Migrations.add
  version: 1
  up: ->
    for oldService in Services.find(type: 'ssh').fetch()
      console.log 'Migrating', oldService
      newService =
        _id: oldService._id
        type: 'ssh'
        info:
          name: oldService.name
          group: oldService.group
          tags: []
        spec:
          cmd: oldService.cmd
          host: oldService.host
          password: oldService.password
          port: oldService.port
          username: oldService.username
        checks: []
      Services.update oldService._id, newService

    for oldService in Services.find(type: 'http').fetch()
      console.log 'Migrating', oldService
      newService =
        _id: oldService._id
        type: 'http'
        info:
          name: oldService.name
          group: oldService.group
          tags: []
        spec:
          url: oldService.url
        checks: [
          checkType: 'httpStatusCheck'
          statusCode: '200'
        ]
      Services.update oldService._id, newService
