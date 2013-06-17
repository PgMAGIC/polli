function ClientCtrl($scope, socket){
	$scope.pollType=""

	$scope.isActivePollType = function(type) {
		return type == $scope.pollType;
	}

	$scope.vote = function(vote){
		socket.emit("vote", vote)
	}

	socket.on("new_poll", function(data){
		if(data.type.substr(0,6) === "choice"){
  			$scope.pollType = data.type;
  			console.log($scope.pollType);
  		} else if(data.type ==="yes_no"){
		   	$scope.pollType = "yes_no";
  		} else if(data.type ==="simple"){
  			$scope.pollType = "simple";
  		}
	})
}

function AdminCtrl($scope, socket){

	$scope.chart = d3.select("#plot").append("svg")
		.attr("class", "chart")
		.attr("width", 500)
		.attr("height", 500);



	socket.on("data:update", function(data){
		console.log(data)

		$scope.chart.append("line")
     		.attr("x1", 0)
     		.attr("x2", 50 * data.length)
     		.attr("y1",  .5)
     		.attr("y2",  .5)
     		.style("stroke", "#dddddd");

		var rect = $scope.chart.selectAll("rect").data(data);
		rect.enter().append("rect")
			.attr("x", function(d, i){return i * 50;})
			.attr("y", 5)
			.attr("width", 20)
			.attr("height", function(d){return d[1] * 50;});

		rect.transition()
			.duration(500)
			.attr("height", function(d){return d[1] * 50;});

		rect.exit().remove();

	})

	$scope.resetPoll = function(){

	}

	$scope.createPoll = function(pollType, count){
		console.log("test")
		$.ajax({
			type: "POST",
			url: "/poll",
			data: {"type" : pollType, "count": count}
		}).then(function(res){
			console.log("RESPONSE: " + res)

			//TODO reset graph
			//create new model
		})
	}
}