bindSocket = (scope, channelName) ->
  socket = io.connect(channelName)
  {
    on: (eventName, callback) ->
      socket.on eventName,  () ->
        args = arguments
        scope.$apply () ->
          callback.apply(socket, args)
    ,
    emit: (eventName, data, callback) ->
      socket.emit eventName, data, () ->
        args = arguments
        scope.$apply () ->
          if (callback)
            callback.apply(socket, args)
  }

app.factory 'clientSocket', ($rootScope) ->
  bindSocket $rootScope, "/client"

app.factory 'adminSocket',  ($rootScope) ->
  bindSocket $rootScope, "/admin"

angular.module("myApp.services", [])