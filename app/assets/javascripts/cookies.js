// Meeting Web - frontend to meeting, elearning & conference system

$(document).on('turbolinks:load', function(){
  $("#cookies-agree-button").click(function() {
    //create a cookie that lasts 1 year
    var cookieDate = new Date();
    cookieDate.setFullYear(cookieDate.getFullYear() + 1); //1 year from now
    document.cookie = "cookie_consented=true; path=/; expires=" + cookieDate.toUTCString() + ";"

    //hide the banner at the bottom
    $(".cookies-banner").attr("style","display:none !important")
  })

  $("#maintenance-close").click(function(event) {
    //create a cookie that lasts 1 day

    var cookieDate = new Date()
    cookieDate.setDate(cookieDate.getDate() + 1) //1 day from now
    console.log("maintenance_window=" + $(event.target).data("date") + "; path=/; expires=" + cookieDate.toUTCString() + ";")

    document.cookie = "maintenance_window=" + $(event.target).data("date") + "; path=/; expires=" + cookieDate.toUTCString() + ";"
  })
})
