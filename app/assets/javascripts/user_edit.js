// Meeting Web - frontend to meeting, elearning & conference system

$(document).on('turbolinks:load', function(){
  var controller = $("body").data('controller');
  var action = $("body").data('action');
  if ((controller == "admins" && action == "edit_user") || (controller == "users" && action == "edit")) {
    // Hack to make it play nice with turbolinks
    if ($("#role-dropdown:visible").length == 0){
      $(window).trigger('load.bs.select.data-api')
    }

    // Check to see if the role dropdown was set up
    if ($("#role-dropdown").length != 0){
      $("#role-dropdown").selectpicker('val', $("#user_role_id").val())
    }

    // Update hidden field with new value
    $("#role-dropdown").on("changed.bs.select", function(){
      $("#user_role_id").val($("#role-dropdown").selectpicker('val'))
    })

    // Update hidden field with new value
    // $("#language-dropdown").on("show.bs.select", function(){
    //   $("#language-dropdown").selectpicker('val', $("#user_language").val())
    // })
    
    // Update hidden field with new value
    $("#language-dropdown").on("changed.bs.select", function(){
      $("#user_language").val($("#language-dropdown").selectpicker('val'))
    })
  }
})