// Meeting Web - frontend to meeting, elearning & conference system

$(document).on('turbolinks:load', function(){
  // Stores the current url when the user clicks the sign in button
  $(".sign-in-button").click(function(){
    var url = location.href
    // Add the slash at the end if it's missing
    url += url.endsWith("/") ? "" : "/"
    document.cookie ="return_to=" + url
  })

  // Checks to see if the user provided an image url and displays it if they did
  $("#user-image")
    .on("load", function() {
      $("#user-image").show()
      $("#user-avatar").hide()
    })
    .on("error", function() {
      $("#user-image").hide()
      $("#user-avatar").show()
    })
})
