var createPoll = function(pollType){
	$.ajax({
		type: "POST",
		url: "/poll",
		data: {"pollType" : pollType}
	}).then(function(res){
		console.log("RESPONSE: " + res)

		
		//TODO reset graph
		//create new model
	})
}