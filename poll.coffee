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
		@voterIds = {}
		@votes = {}

	voteCheck : (id)=>
		valid = not @voterIds[id]
		console.log(@voterIds)
		@voterIds[id] = true
		valid

class PollChoice extends Poll

	constructor: (@count) ->
		super()
		@type = "choice" + @count
		@votes = {}
		for i in [1..@count]
			@votes[i] = 0
		console.log(@voterIds)

	vote : (vote, id)=>
		valid = @voteCheck(id)
		if valid
			console.log "Valid vote"
			@votes[vote]+=1

class PollYesNo extends Poll
	type : "yes_no"
	constructor: () ->
		super()
		@votes =
			yes: 0
			no: 0	

	vote: (vote, id)=>
		if @voteCheck(id)
			if vote == "no"
				@votes.no+=1
			else if vote == "yes"
				@votes.yes+=1

class PollSimple extends Poll
	constructor: () ->
		super()
		@votes = {yes : 0}
		@type = "simple"

	vote : (id) =>
		if @voteCheck(id)
			@votes["yes"]+=1
