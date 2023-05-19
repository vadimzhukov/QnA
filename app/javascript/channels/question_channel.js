import consumer from "./consumer"
const templateAnswer = require("../templates/answer.hbs")

$(document).on("turbolinks:load", function() {
  const question_id = gon.question_id
  if (question_id) {
    
    const answersList = $(".answers-list")
    const channel = "QuestionChannel"

    consumer.subscriptions.create({ 
      channel: channel, 
      question_id: question_id},

      {
      connected() {
        console.log("Connected to channel: question_" + question_id)
        },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

        received(data) {
          if (gon.current_user_id != data.answer.author_id || !gon.current_user_id) {
            data.userSignedIn = document.cookie.indexOf("signed_in=1") > -1;
            const answer = templateAnswer(data)
            answersList.append(answer)
          }
        }
      });
    }
});
