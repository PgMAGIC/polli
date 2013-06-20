connect = require("connect")
express = require("express")
io = require("socket.io")
_ = require("underscore")
Poll = require("./poll")
QRCode = require('qrcode');
http = require('http')

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
io.sockets.on "connection", (socket) ->

  socket.broadcast.emit "clientcount:update", Object.keys(io.sockets.manager.connected).length

  cookies = {}
  socket.handshake.headers.cookie && socket.handshake.headers.cookie.split(';').forEach (cookie) ->
    parts = cookie.split '='
    cookies[parts[0].trim()] = (parts[1] || '').trim()
  
  pollerId = cookies["connect.sid"]

  socket.emit "new_poll",
    type: myPoll.type

  socket.on "vote", (data) ->
    myPoll.vote data, pollerId 
    socket.broadcast.emit "data:update", _.pairs(myPoll.votes)

  socket.on "disconnect", ->
    socket.broadcast.emit "clientcount:update", Object.keys(io.sockets.manager.connected).length

  socket.on "poll:reset", ->
    console.log "Reset poll"
    myPoll.reset()


server.get "/", (req, res) ->
  res.render "index.jade",
    locals:
      title: "Your Page Title"
      description: "Your Page Description"
      author: "Your Name"
      analyticssiteid: "XXXXXXX"


server.post "/poll", (req, res) ->
  console.log(req.sessionID)
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

server.get "/qrcode", (req, res) ->
  QRCode.draw "http://192.168.100.42:8081/poll", (err, data)->
    data.pngStream().pipe(res)


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