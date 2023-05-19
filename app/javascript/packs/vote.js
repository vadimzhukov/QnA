$(document).on("turbolinks:load", function() {
  $(".votes").on("ajax:success", function(e) {
    console.log("--- мы тут пытаемся поменять голосовалку ----")
    const votableId = e.detail[0].id
    const votesSum = e.detail[0].votes_sum
  
    const vote_direction = e.detail[0].vote_direction

    // этот код тоже похоже не оптимален :( как его можно улучшить?
    $("#votes-count-" + votableId).html("<span>" + votesSum + "</span>");
    if (vote_direction === true) {
      $(".like-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".dislike-votable[data-votable-id='" + votableId + "']").addClass("hidden")
      $(".reset-like-votable[data-votable-id='" + votableId + "']").removeClass("hidden")
      $(".reset-dislike-votable[data-votable-id='" + votableId + "']").addClass("hidden")
    } else if (vote_direction === false) {
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
})