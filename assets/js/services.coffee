app.factory('clientSocket', ($rootScope) ->
  socket = io.connect("/client")
  {
    on: (eventName, callback) ->
      socket.on eventName,  () ->
        args = arguments
        $rootScope.$apply( () ->
          callback.apply(socket, args)
        )
    ,
    emit: (eventName, data, callback) ->
      socket.emit eventName, data, () ->
        args = arguments;
        $rootScope.$apply () ->
          if (callback)
            callback.apply(socket, args)
  }
)

app.factory('adminSocket',  ($rootScope) ->
  socket = io.connect("/admin")
  {
    on: (eventName, callback) ->
      socket.on eventName,  () ->
        args = arguments
        $rootScope.$apply () ->
          callback.apply(socket, args)
    ,
    emit: (eventName, data, callback) ->
      socket.emit eventName, data, () ->
        args = arguments
        $rootScope.$apply () ->
          if (callback)
            callback.apply(socket, args)
  }
)

angular.module("myApp.services", [])