$(document).on("turbolinks:load", function() {
  $(".questions-list").on("click", ".edit-question-link", function(e) {
    e.preventDefault()
    $(this).hide()
    const questionId = $(this).data("questionId")
    $("#question-" + questionId + " .current-content").hide()
    $("#delete-question-" + questionId).hide()
    $("form#edit-question-" + questionId).removeClass("hidden")
  })
})