connect = require("connect")
express = require("express")
io = require("socket.io")
_ = require("underscore")
Poll = require("./models/poll.js")

port = (process.env.PORT or 8081)

myPoll = Poll.create("choice", 4)
server = express.createServer()

server.configure ->
  server.set "views", __dirname + "/views"
  server.set "view options",
    layout: false

  server.use connect.bodyParser()
  server.use express.cookieParser()
  server.use require('connect-assets')(
    
  )
  server.use express.session(secret: "shhhhhhhhh!")
  server.use connect.static(__dirname + "/static")
  server.use server.router
  

server.helpers _: require("underscore")
server.error (err, req, res, next) ->
  if err instanceof NotFound
    res.render "404.jade",
      locals:
        title: "404 - Not Found"
        description: ""
        author: ""
        analyticssiteid: "XXXXXXX"

      status: 404

  else
    res.render "500.jade",
      locals:
        title: "The Server Encountered an Error"
        description: ""
        author: ""
        analyticssiteid: "XXXXXXX"
        error: err

      status: 500


server.listen port
io = io.listen(server)
io.sockets.on "connection", (socket) ->
  console.log "Client Connected"
  socket.emit "new_poll",
    type: myPoll.type

  socket.on "vote", (data) ->
    myPoll.vote data
    socket.broadcast.emit "data:update", _.pairs(myPoll.votes)

  socket.on "disconnect", ->
    console.log "Client Disconnected."


server.get "/", (req, res) ->
  res.render "index.jade",
    locals:
      title: "Your Page Title"
      description: "Your Page Description"
      author: "Your Name"
      analyticssiteid: "XXXXXXX"


server.post "/poll", (req, res) ->
  pollType = req.body.type
  pollCount = req.body.count or false
  polldata = {}
  pollType += pollCount  if pollCount
  polldata.type = pollType
  myPoll = Poll.create(pollType, pollCount)
  io.sockets.emit "new_poll", polldata
  res.end "SUCCESS"

server.get "/admin", (req, res) ->
  res.render "admin.jade",
    locals:
      title: "Your Page Title"
      description: "Your Page Description"
      author: "Your Name"
      analyticssiteid: "XXXXXXX"


server.get "/poll", (req, res) ->
  res.render "client.jade",
    locals:
      title: "Your Page Title"
      description: "Your Page Description"
      author: "Your Name"
      analyticssiteid: "XXXXXXX"


server.get "/500", (req, res) ->
  throw new Error("This is a 500 Error")

# server.get "/*", (req, res) ->
#   console.log(req.url)
#   throw new NotFound

NotFound = (msg) ->
  @name = "NotFound"
  Error.call this, msg
  Error.captureStackTrace this, arguments_.callee

console.log "Listening on http://0.0.0.0:" + port