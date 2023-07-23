import consumer from "./consumer"
import channelExisted from "./check_existed_channel"
import {renderLikes} from "../packs/vote.js"

const templateAnswer = require("../templates/answer.hbs")

$(document).on("turbolinks:load", function() {
  
  const question_id = gon.question_id
  
  if (question_id) {
    
    const answersList = $(".answers-list")
    const channel = "QuestionChannel"

    if (channelExisted(channel, "question_id", question_id)) return

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
          if (gon.sid === data.sid) return
            
          const userSignedIn = document.cookie.includes("signed_in=1")

          data.userSignedIn = userSignedIn

          const answer = templateAnswer(data)
          answersList.append(answer)
          
          renderLikes()
        }
      });
    }
});
