angular.module('myApp').controller 'ClientCtrl', ($scope, clientSocket) ->
  $scope.pollType = ""
  $scope.hasPolled = false

  $scope.isActivePollType = (type) ->
    type is $scope.pollType

  $scope.vote = (vote) ->
    clientSocket.emit "vote", vote
    $scope.hasPolled = true

  clientSocket.on "poll:new", (data) ->
    $scope.hasPolled = false
    if data.type.substr(0, 6) is "choice"
      $scope.pollType = data.type
      console.log $scope.pollType
    else if data.type is "yes_no"
      $scope.pollType = "yes_no"
    else $scope.pollType = "simple"  if data.type is "simple"

  clientSocket.on "poll:finished", () ->
    $scope.hasPolled = true

  $(window).resize(()->
    $('.button').each( (i, elem)->
      console.log $(elem).height()
      $(elem).css("line-height", $(elem).height()+"px")
    )
  )

  $('.button').each( (i, elem)->
    $(elem).css("line-height", $(elem).height()+"px")
  )