/* Author: YOUR NAME HERE
*/

$(document).ready(function() {   

  var socket = io.connect();

  $('#sender').bind('click', function() {
   socket.emit('message', 'Message Sent on ' + new Date());     
  });

  socket.on('server_message', function(data){
   $('#receiver').append('<li>' + data + '</li>');  
  });

  socket.on('new_poll', function(data){
  	if(data.type === "choice"){
  		var count = data.count;
  		createChoicePoll(count);
  	} else if(data.type ==="yes_no"){
		yesNoPoll()
  	} else if(data.type ==="simple"){
  		simplePoll()
  	}
  })
});