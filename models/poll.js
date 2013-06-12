var _ = require('underscore');

exports.create = function(type, count){
	console.log(type)
	if(type === "choice"){
  		return PollChoice({count: count});//createChoicePoll(count);
  	} else if(type ==="yes_no"){
		return PollYesNo();
  	} else if(type ==="simple"){
  		return PollSimple();
  	}
}

var Poll = function(spec){
	var that = spec || {};

	/*that.vote = function(vote){
		console.log("Asdf: " + that.votes);
	}*/

	that.votes = {};

	return that;
}

var PollYesNo = function(spec){
	var that = Poll(spec);
	that.votes = {no: 0, yes: 0}

	that.vote = function(vote){
		if(vote == "no") that.votes.no+=1;
		else if(vote=== "yes") that.votes.yes+=1;
		console.log("Votes: " + that.votes.yes);
	}

	return that;
}

var PollChoice = function(spec){
	var that = Poll(spec);

	for(var i = 1 ; i<= spec.count; i++){
		that.votes[i] = 0;	
	}

	that.vote = function(vote){
		that.votes[vote]+=1;
	}

	return that;
}

var PollSimple = function(spec){
	var that = Poll(spec);
	that.votes = {"yes": 0}

	that.vote = function(vote){
		that.votes["yes"] += 1;
	}

	return that;
}