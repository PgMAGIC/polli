function ClientCtrl($scope, socket){
	$scope.pollType="choice4"

	$scope.isActivePollType = function(type) {
		return type == $scope.pollType;
	}

	$scope.vote = function(vote){
		socket.emit("vote", vote)
	}

	socket.on("new_poll", function(data){
		if(data.type === "choice"){
  			$scope.pollType = "choice" + data.count;
  			console.log($scope.pollType)
  		} else if(data.type ==="yes_no"){
		   	$scope.pollType = "yes_no";
  		} else if(data.type ==="simple"){
  			$scope.pollType = "simple";
  		}
	})
}

function AdminCtrl($scope){

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