// Meeting Web - frontend to meeting, elearning & conference system

// Handle client request to join when meeting starts.
$(document).on("turbolinks:load", function(){
  var controller = $("body").data('controller');
  var action = $("body").data('action');

  if(controller == "rooms" && action == "join"){
    App.waiting = App.cable.subscriptions.create({
      channel: "WaitingChannel",
      roomuid: $(".background").attr("room"),
      useruid: $(".background").attr("user")
    }, {
      connected: function() {
        console.log("connected");
        setTimeout(startRefreshTimeout, 120000);
      },

      disconnected: function(data) {
        console.log("disconnected");
        console.log(data);
      },

      rejected: function() {
        console.log("rejected");
      },

      received: function(data){
        console.log(data);
        if(data.action == "started"){
          request_to_join_meeting();
        }
      }
    });
  }
});

var join_attempts = 0;

function request_to_join_meeting() {
  $.post(window.location.pathname, { join_name: $(".background").attr("join-name") }, function() {
    //Successful post - set up retry incase
    if(join_attempts < 4){ setTimeout(request_to_join_meeting, 10000); }
    join_attempts++;
  })
}

// Refresh the page after 2 mins and attempt to reconnect to ActionCable 
function startRefreshTimeout() {
  var url = new URL(window.location.href)
  url.searchParams.set("reload","true")
  window.location.href = url.href
}
