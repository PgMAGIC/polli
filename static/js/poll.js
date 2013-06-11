var createPoll = function(pollType, count){
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

$('#yesNoControlls').click(function(){createPoll('yes_no');})
$('#choice1Button').click(function(){createPoll('choice', 1);})
$('#choice2Button').click(function(){createPoll('choice', 2);})
$('#choice3Button').click(function(){createPoll('choice', 3);})
$('#choice4Button').click(function(){createPoll('choice', 4);})
$('#choice5Button').click(function(){createPoll('choice', 5);})
$('#choice6Button').click(function(){createPoll('choice', 6);})
$('#choice7Button').click(function(){createPoll('choice', 7);})
$('#choice8Button').click(function(){createPoll('choice', 8);})
$('#choice9Button').click(function(){createPoll('choice', 9);})
$('#simpleButton').click(function(){createPoll('simple');})