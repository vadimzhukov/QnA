$(document).on("turbolinks:load", function() {
  $(".questions-list").on("click", ".edit-question-link", function(e) {
    e.preventDefault()
    $(this).hide()
    const questionId = $(this).data("questionId")
    $("#question-" + questionId + " .current-content").hide()
    $("#delete-question-" + questionId).hide()
    $("form#edit-question-" + questionId).removeClass("hidden")
  })

  $(".votes").on("ajax:success", function(e) {
    const questionId = e.detail[0].question.id
    const votesCount = e.detail[0].votes_count
    let current_user_voted = false
    if (e.detail[0].current_user_votes > 0) {
      current_user_voted = true 
    } else {
      current_user_voted = false
    }
    console.log(e.detail[0])

    $("#votes-count-" + questionId).html("<span>" + votesCount + "</span>");
    if (current_user_voted) {
      $("#question-" + questionId + " .like-question").addClass("btn disabled")
      $("#question-" + questionId + " .dislike-question").removeClass("btn disabled")
    } else {
      $("#question-" + questionId + " .dislike-question").addClass("btn disabled")
      $("#question-" + questionId + " .like-question").removeClass("btn disabled")
    }
  })
})