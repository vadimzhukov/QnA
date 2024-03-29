import consumer from "./consumer"
import channelExisted from "./check_existed_channel"
import {renderLikes} from "../packs/vote.js"


const templateQuestion = require("../templates/question.hbs")

$(document).on("turbolinks:load", function() {
  
  const questionsList = $(".questions-list")
  const channel = "QuestionsChannel"

  if (channelExisted(channel)) return

  consumer.subscriptions.create(channel, {
    connected() {
      console.log("Connected to channel: " + channel)
      },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.sid === data.sid) return
      
      const userSignedIn = document.cookie.includes("signed_in=1")

      data.userSignedIn = userSignedIn
      const question = templateQuestion(data)
      questionsList.append(question)
      
      renderLikes()
    }
  });
});
