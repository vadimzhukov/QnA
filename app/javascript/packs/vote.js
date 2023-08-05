
export function renderLikes() {
  $(".votes").on("ajax:success", function(e) {
    const votableId = e.detail[0].id
    const votesSumByUser = e.detail[0].votes_sum_by_user
    const votesSum = e.detail[0].votes_sum
  
    // этот код тоже похоже не оптимален :( как его можно улучшить?
    $("#votes-count-" + votableId).html("<span>" + votesSum + "</span>");
    if (votesSumByUser === 1) {
      $(".like-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".dislike-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".reset-like-votable[data-votable-id='" + votableId + "']").removeClass("hidden")
      $(".reset-dislike-votable[data-votable-id='" + votableId + "']").addClass("hidden")
    } else if (votesSumByUser === -1) {
      $(".like-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".dislike-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".reset-like-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".reset-dislike-votable[data-votable-id='" + votableId + "']").removeClass("hidden")
    } else {
      $(".like-votable[data-votable-id='" + votableId + "']").removeClass("hidden")
      $(".dislike-votable[data-votable-id='" + votableId + "']").removeClass("hidden")
      $(".reset-like-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".reset-dislike-votable[data-votable-id='" + votableId + "']").addClass("hidden")
    }
  })
}

$(document).on("turbolinks:load", function() {
  renderLikes()
})

