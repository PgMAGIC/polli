angular.module('myApp').controller 'ClientCtrl', ($scope, socket) ->
  $scope.pollType = ""
  $scope.isActivePollType = (type) ->
    type is $scope.pollType

  $scope.vote = (vote) ->
    socket.emit "vote", vote

  socket.on "new_poll", (data) ->
    if data.type.substr(0, 6) is "choice"
      $scope.pollType = data.type
      console.log $scope.pollType
    else if data.type is "yes_no"
      $scope.pollType = "yes_no"
    else $scope.pollType = "simple"  if data.type is "simple"