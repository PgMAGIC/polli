var socket;

$(document).ready(function() {   

  socket = io.connect();

  socket.on('new_poll', function(data){
  	
  })
});