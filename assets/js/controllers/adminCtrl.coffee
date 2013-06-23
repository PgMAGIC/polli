angular.module('myApp').controller 'AdminCtrl', ($scope, adminSocket) ->
  $scope.chart = d3.select("#plot")
    .append("svg")
    .attr("class", "chart")
    .attr("width", "100%")
    .attr("viewBox", "0 0 1200 500")

  ratio = 2/3
  $(".chart").attr("height", $(".chart").width() * ratio);

  $scope.clientCount = 0

  height = 500
  width = 1200

  $scope.data = []



  drawPoll = () ->
    console.log $scope.data
    leftOffset = 50
    barWidth = (width - leftOffset)/($scope.data.length * 2)
    xOrd = d3.scale.ordinal().domain(d3.range($scope.data.length)).rangeBands([0, width], .20)
    y = d3.scale.linear().
      domain([0,$scope.clientCount])
      .rangeRound([0, height])
    $scope.chart.append("line").attr("x1", 0)
      .attr("x2", width)
      .attr("y1", height - .5)
      .attr("y2", height - .5)
      .style "stroke", "#dddddd"
    rect = $scope.chart.selectAll("rect").data($scope.data)
    rect.enter().append("rect")
      .attr("x", (d, i) -> xOrd(i))
      .attr("y", (d) -> height - y(d[1]) - .5)
      .attr("width", xOrd.rangeBand())
      .attr "height", (d) ->
        y(d[1])

    rect.transition().duration(500)
      .attr "height", (d) ->
        y(d[1])
      .attr("width", xOrd.rangeBand())
      .attr("x", (d, i) -> xOrd(i))
      .attr("y", (d) -> height - y(d[1]) - .5)

    rect.exit().remove()

    text = $scope.chart.selectAll("text.count").data($scope.data)
    text.enter().append("text")
      .attr("x", (d,i) -> xOrd(i) + xOrd.rangeBand() / 2)
      .attr("y", (d) -> height - y(d[1]) - 10)
      .attr("fill", "#dddddd")
      .attr("font-size", "72px")
      .attr("text-anchor", "middle")
      .text( (d) -> d[1])
      .attr("class", "count")

    text.exit().remove()

    text.transition().duration(500)
      .attr("y", (d) -> height - y(d[1]) - 10)
      .attr("x", (d,i) -> xOrd(i) + xOrd.rangeBand() / 2)
      .text( (d) -> d[1])

    text2 = $scope.chart.selectAll("text.label2").data($scope.data)
    text2.enter().append("text")
    .attr("x", (d,i) -> xOrd(i) + xOrd.rangeBand() / 2)
    .attr("y", height + 65)
    .attr("fill", "#dddddd")
    .attr("font-size", "72px")
    .attr("text-anchor", "middle")
    .text( (d) -> d[0])
    .attr("class", "label2")

    text2.transition().duration(500)
    .text( (d) -> d[0])
    .attr("x", (d,i) -> xOrd(i) + xOrd.rangeBand() / 2)

    text2.exit().remove()


  drawPoll()

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

    $(".chart").attr("height", $(".chart").width() * ratio);
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