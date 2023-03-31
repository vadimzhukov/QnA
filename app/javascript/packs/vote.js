$(document).on("turbolinks:load", function() {
  $(".votes").on("ajax:success", function(e) {
    const votableId = e.detail[0].id
    const votesCount = e.detail[0].votes_count
    const current_user_voted = e.detail[0].current_user_voted

    $("#votes-count-" + votableId).html("<span>" + votesCount + "</span>");
    if (current_user_voted) {
      console.log("[data-votable-id = '" + votableId + "', .like-votable")
      console.log("[data-votable-id = '" + votableId + "', .dislike-votable]")
      $(".like-votable[data-votable-id='" + votableId + "']").addClass("btn btn-link disabled")
      $(".dislike-votable[data-votable-id='" + votableId + "']").removeClass("btn btn-link disabled")
    } else {
      $(".dislike-votable[data-votable-id='" + votableId + "']").addClass("btn btn-link disabled")
      $(".like-votable[data-votable-id='" + votableId + "']").removeClass("btn btn-link disabled")
    }
  })
})