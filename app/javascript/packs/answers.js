$(document).on("turbolinks:load", function() {
  $(".answers-list").on("click", ".edit-answer-link", function(e) {
    e.preventDefault()
    $(this).hide()
    const answerId = $(this).data("answerId")
    $("form#edit-answer-" + answerId).removeClass("hidden")
    $("#delete-answer-" + answerId).hide()
    $("#best-answer-btn-" + answerId).hide()
  })
})