angular.module('myApp').controller 'AdminCtrl', ($scope, adminSocket) ->
  $scope.chart = d3.select("#plot")
    .append("svg")
    .attr("class", "chart")
    .attr("width", 500)
    .attr("height", 300)
  $scope.clientCount = 0

  height = 300

  drawPoll = () ->
    console.log($scope.clientCount)
    y = d3.scale.linear().
      domain([0,$scope.clientCount])
      .rangeRound([0, height])
    $scope.chart.append("line").attr("x1", 0)
      .attr("x2", 50 * $scope.data.length)
      .attr("y1", height - .5)
      .attr("y2", height - .5)
      .style "stroke", "#dddddd"
    rect = $scope.chart.selectAll("rect").data($scope.data)
    rect.enter().append("rect")
      .attr("x", (d, i) ->
        i * 50
      )
      .attr("y", (d) -> height - y(d[1]) - .5)
      .attr("width", 20)
      .attr "height", (d) ->
        y(d[1])

    rect.transition().duration(500)
      .attr "height", (d) ->
        y(d[1])
      .attr("y", (d) -> height - y(d[1]) - .5)

    rect.exit().remove()

  adminSocket.on "clientcount:update", (data)->
    console.log("Update client count " + data)
    $scope.clientCount = data
    drawPoll()

  adminSocket.on "data:update", (data) ->
    $scope.data = data
    drawPoll()

  $(window).resize(()->
    $('.button').each( (i, elem)->
      $(elem).css("line-height", $(elem).height()+"px")
    )
  )

  $('.button').each( (i, elem)->
    $(elem).css("line-height", $(elem).height()+"px")
  )

  $scope.resetPoll = () ->
    console.log("RESET")
    adminSocket.emit("poll:reset")

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