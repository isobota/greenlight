// Meeting Web - frontend to meeting, elearning & conference system

$(document).on('turbolinks:load', function(){
  $.rails.refreshCSRFTokens();
})

document.addEventListener("turbolinks:before-cache", function() {
  $(".alert").remove()
})

// Gets the localized string
function getLocalizedString(key) {
  var keyArr = key.split(".")
  var translated = I18n

  // Search current language for the key
  try {
    keyArr.forEach(function(k) {
      translated = translated[k]
    })
  } catch (e) {
    // Key is missing in selected language so default to english
    translated = undefined;
  }


  // If key is not found, search the fallback language for the key
  if (translated === null || translated === undefined) { 
    translated = I18nFallback

    keyArr.forEach(function(k) {
      translated = translated[k]
    })
  }

  return translated
}