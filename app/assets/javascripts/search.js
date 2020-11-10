// Meeting Web - frontend to meeting, elearning & conference system

$(document).on('turbolinks:load', function(){
  var controller = $("body").data('controller');
  var action = $("body").data('action');

  if ((controller == "admins" && action == "index") || 
      (controller == "rooms" && action == "show") || 
      (controller == "rooms" && action == "update") ||
      (controller == "rooms" && action == "join") || 
      (controller == "users" && action == "recordings") ||
      (controller == "admins" && action == "server_recordings") ||
      (controller == "admins" && action == "server_rooms")) {
    // Submit search if the user hits enter
    $("#search-input").keypress(function(key) {
      if (key.which == 13) {
        searchPage()
      }
    })

    // Add listeners for sort
    $("th[data-order]").click(function(data){
      var header_elem = $(data.target)

      if(header_elem.data('order') === 'asc'){ // asc
        header_elem.data('order', 'desc');
      }
      else if(header_elem.data('order') === 'desc'){ // desc
        header_elem.data('order', 'none');
      }
      else{ // none
        header_elem.data('order', 'asc');
      }

      var search = $("#search-input").val();

      var url = window.location.pathname + "?page=1&search=" + search + "&column=" + header_elem.data("header") +
       "&direction=" + header_elem.data('order')

      window.location.replace(addRecordingTable(url))
    })

    if(controller === "rooms" && action === "show"){
      $(".page-item > a").each(function(){
        if(!$(this).attr('href').endsWith("#")){
          $(this).attr('href', $(this).attr('href') + "#recordings-table")
        }
      })
    }
  }
})

// Searches the user table for the given string
function searchPage() {
  var search = $("#search-input").val();

  // Check if the user filtered by role
  var role = new URL(location.href).searchParams.get('role')
  var tab = new URL(location.href).searchParams.get('tab')

  var url = window.location.pathname + "?page=1&search=" + search

  if (role) { url += "&role=" + role } 
  if (tab) { url += "&tab=" + tab } 

  window.location.replace(addRecordingTable(url));
}

// Clears the search bar
function clearSearch() {
  var role = new URL(location.href).searchParams.get('role')
  var tab = new URL(location.href).searchParams.get('tab')

  var url = window.location.pathname + "?page=1"

  if (role) { url += "&role=" + role } 
  if (tab) { url += "&tab=" + tab } 
  
  window.location.replace(addRecordingTable(url));

  var search_params = new URLSearchParams(window.location.search)
}

function addRecordingTable(url) {
  if($("body").data('controller') === "rooms" && $("body").data('action') === "show") { 
    url += "#recordings-table"
  }
  return url
}
