function ClientCtrl($scope, socket){
	$scope.pollType="choice4"

	$scope.isActivePollType = function(type) {
		console.log(type)
		return type == $scope.pollType;
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