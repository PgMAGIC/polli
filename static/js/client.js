var createChoicePoll = function(num){
	$("#controlls>div").addClass('hidden');
	$("#choice" + num + "Controlls").removeClass('hidden');
}

var yesNoPoll = function(){
	console.log("test")
	$("#controlls>div").addClass('hidden');
	$("#yesNoControlls").removeClass('hidden');
}

var simplePoll = function(){
	$("#controlls>div").addClass('hidden');
	$("#singleControlls").removeClass('hidden');
}