connect = require("connect")
express = require("express")
io = require("socket.io")
_ = require("underscore")
Poll = require("./poll")
QRCode = require('qrcode');
http = require('http')
dns = require('dns')


port = (process.env.PORT or 8081)

myPoll = Poll.create("choice", 4)
server = express()
httpServer = http.createServer(server)
httpServer.listen(port)

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
  

server.locals._ = require("underscore")
server.use (err, req, res, next) ->
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


io = io.listen(httpServer)
clientChannel = io.of('/client').on "connection", (socket) ->
  console.log "CLIENT CONNECTED"
  adminChannel.emit "clientcount:update", Object.keys(io.sockets.clients('client')).length

  cookies = {}
  socket.handshake.headers.cookie && socket.handshake.headers.cookie.split(';').forEach (cookie) ->
    parts = cookie.split '='
    cookies[parts[0].trim()] = (parts[1] || '').trim()
  
  pollerId = cookies["connect.sid"]
  console.log pollerId
  console.log myPoll

  # check if already have polled
  # if redirect to right window
  if myPoll.hasVoted(pollerId)
    socket.emit "poll:finished"
  else
    socket.emit "new_poll",
      type: myPoll.type

  socket.on "vote", (data) ->
    myPoll.vote data, pollerId 
    adminChannel.emit "data:update", _.pairs(myPoll.votes)

  socket.on "disconnect", ->
    console.log "Disconnected!"
    adminChannel.emit "clientcount:update", Object.keys(io.sockets.clients('client')).length



adminChannel = io.of('/admin').on "connection", (socket) ->
  console.log "Admin connected"
  socket.on "poll:reset", ->
    myPoll.reset()
    clientChannel.emit "new_poll", type: myPoll.type
    adminChannel.emit "data:update", _.pairs(myPoll.votes)

  socket.on "new_poll", ->
    myPoll.reset()
    adminChannel.emit "data:update", _.pairs(myPoll.votes)



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

  clientChannel.emit "new_poll", polldata
  adminChannel.emit "data:update", polldata

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

server.get "/qrcode", (req, res) ->
  dns.lookup(require('os').hostname(),  (err, add, fam) ->
    console.log add
    QRCode.draw "http://"+add + ":" + port + "/poll", (err, data)->
      data.pngStream().pipe(res)
  )

server.get "/qrcode-bits", (req, res) ->
  dns.lookup(require('os').hostname(),  (err, add, fam) ->
    QRCode.drawBitArray "http://"+add + ":" + port + "/poll", (err, data, width)->
      res.end JSON.stringify({
        bits: data,
        width: width
      })
  )

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