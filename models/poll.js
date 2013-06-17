var _ = require('underscore');

exports.create = function(type, count){
	console.log(type + " " + count)
	if(type.substr(0,6) === "choice"){
  		return PollChoice({count: count});//createChoicePoll(count);
  	} else if(type ==="yes_no"){
		return PollYesNo();
  	} else if(type ==="simple"){
  		return PollSimple();
  	}
}

var Poll = function(spec){
	var that = spec || {};

	that.votes = {};

	return that;
}

var PollYesNo = function(spec){
	var that = Poll(spec);
	that.votes = {no: 0, yes: 0}

	that.vote = function(vote){
		if(vote == "no") that.votes.no+=1;
		else if(vote=== "yes") that.votes.yes+=1;
		console.log(that.votes);
	}

	that.type="yes_no";

	return that;
}

var PollChoice = function(spec){
	var that = Poll(spec);

	for(var i = 1 ; i<= spec.count; i++){
		that.votes[i] = 0;	
	}

	that.vote = function(vote){
		that.votes[vote]+=1;
		console.log(that.votes)
	}

	that.type="choice" + spec.count;

	return that;
}

var PollSimple = function(spec){
	var that = Poll(spec);
	that.votes = {"yes": 0}

	that.vote = function(vote){
		that.votes["yes"] += 1;
		console.log(that.votes)
	}

	that.type="simple";

	return that;
}