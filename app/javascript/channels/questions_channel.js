import consumer from "./consumer"
const templateQuestion = require("../templates/question.hbs")

$(document).on("turbolinks:load", function() {
  
  const questionsList = $(".questions-list")
  const channel = "QuestionsChannel"

  consumer.subscriptions.create(channel, {
    connected() {
      console.log("Connected to channel: " + channel)
      },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.current_user_id != data.question.author_id || !gon.current_user_id) {
        data.userSignedIn = document.cookie.indexOf("signed_in=1") > -1;
        const question = templateQuestion(data)
        questionsList.append(question)
      }
    }
  });
});
