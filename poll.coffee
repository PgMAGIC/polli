_ = require('underscore');
module.exports.create = (type, count)->
	console.log(type + " " + count)
	if type.substr(0,6) == "choice"
		new PollChoice(count)
	else if type == "yes_no"
		new PollYesNo()
	else if type == "simple"
		new PollSimple()

class Poll
	constructor : ()->
		@reset()

	voteCheck : (id)=>
		valid = not @voterIds[id]
		console.log("Vote was: " + valid + " Id: " + id)
		@voterIds[id] = true
		valid

	reset : () ->
		@voterIds = {}
		@votes = {}

	hasVoted : (id) ->
		!!@voterIds[id]



class PollChoice extends Poll

	constructor: (@count) ->
		super()
		@type = "choice" + @count
		@reset()
		

	vote : (vote, id)=>
		valid = @voteCheck(id)
		if valid
			@votes[vote]+=1

	reset : () ->
		console.log("RESET CHOICE")
		super()
		@votes = {}
		for i in [1..@count]
			@votes[i] = 0


class PollYesNo extends Poll
	type : "yes_no"
	constructor: () ->
		super()
		@reset()

	vote: (vote, id)=>
		if @voteCheck(id)
			if vote == "no"
				@votes.no+=1
			else if vote == "yes"
				@votes.yes+=1

	reset: () ->
		super()
		@votes =
			yes: 0
			no: 0

class PollSimple extends Poll
	constructor: () ->
		super()
		@reset()
		@type = "simple"

	vote : (id) =>
		if @voteCheck(id)
			@votes["yes"]+=1

	reset : ()->
		super()
		@votes = {yes : 0}
