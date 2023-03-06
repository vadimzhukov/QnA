$(document).on("turbolinks:load", function() {
  $(".questions-list").on("click", ".edit-question-link", function(e) {
    e.preventDefault()
    $(this).hide()
    const questionId = $(this).data("questionId")
    $("form#edit-question-" + questionId).removeClass("hidden")
  })
})