// Meeting Web - frontend to meeting, elearning & conference system

$(document).on('turbolinks:load', function(){
  var controller = $("body").data('controller');
  var action = $("body").data('action');

  // Only run on the admins page.
  if (controller == "admins" && action == "index") {
    // show the modal with the correct form action url
    $(".delete-user").click(function(){
      $("#delete-confirm").parent().attr("action", $(this).data("path"))

      if ($(this).data("delete") == "temp-delete") {
        $("#perm-delete").hide()
        $("#delete-warning").show()
      } else {
        $("#perm-delete").show()
        $("#delete-warning").hide()
      }
    })
  }

  $(".delete-user").click(function(data){
    document.getElementById("delete-checkbox").checked = false
    $("#delete-confirm").prop("disabled", "disabled")

    if ($(data.target).data("delete") == "temp-delete") {
      $("#perm-delete").hide()
      $("#delete-warning").show()
    } else {
      $("#perm-delete").show()
      $("#delete-warning").hide()
    }
  })

  $("#delete-checkbox").click(function(data){
    if (document.getElementById("delete-checkbox").checked) {
      $("#delete-confirm").removeAttr("disabled")
    } else {
      $("#delete-confirm").prop("disabled", "disabled")
    }
  })
})
