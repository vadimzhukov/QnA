$(document).on("turbolinks:load", function() {
  $(".comment-button").on("click", function(e) {
    e.preventDefault()
    
    const commentableID = $(this).attr("id")

    

    $('form#commented-resource-' + commentableID).find("textarea").val("")
    $('form#commented-resource-' + commentableID).show()
    $('a.comment-button#'+commentableID).hide()
  })
  $(".submit-comment-button").on("click", function(e) {
    const commentableID = $(this).attr("id")
    
    $('form#commented-resource-' + commentableID).hide()
    $('a.comment-button#'+commentableID).show()
    $('#comment-delete-button-' + commentableID).show()
  
  })

})