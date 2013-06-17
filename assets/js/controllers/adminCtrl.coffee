

angular.module('myApp').controller 'AdminCtrl', ($scope, socket) ->
  $scope.chart = d3.select("#plot").append("svg").attr("class", "chart").attr("width", 500).attr("height", 500)
  socket.on "data:update", (data) ->
    console.log data
    $scope.chart.append("line").attr("x1", 0).attr("x2", 50 * data.length).attr("y1", .5).attr("y2", .5).style "stroke", "#dddddd"
    rect = $scope.chart.selectAll("rect").data(data)
    rect.enter().append("rect").attr("x", (d, i) ->
      i * 50
    ).attr("y", 5).attr("width", 20).attr "height", (d) ->
      d[1] * 50

    rect.transition().duration(500).attr "height", (d) ->
      d[1] * 50

    rect.exit().remove()

  $scope.resetPoll = ->

  $scope.createPoll = (pollType, count) ->
    console.log "test"
    $.ajax(
      type: "POST"
      url: "/poll"
      data:
        type: pollType
        count: count
    ).then (res) ->
      console.log "RESPONSE: " + res


#TODO reset graph
#create new model