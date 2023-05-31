import consumer from "./consumer"
import channelExisted from "./check_existed_channel"

const templateComment = require("../templates/comment.hbs")

$(document).on("turbolinks:load", function() {
    const channel = "CommentsChannel"

    if (channelExisted(channel)) return

    consumer.subscriptions.create(channel, {
      connected() {
        console.log("Connected to channel: " + channel)
        },
      disconnected() {},
      received(data) {
        const comment = templateComment(data)

        const commented_resource_type = data.comment.commentable_type.toLowerCase()
        const commented_resource_id = data.comment.commentable_id
        const commented_element_id = `#${commented_resource_type}-${commented_resource_id}` 
        
        const commentsList = $(commented_element_id).find(".comments")

        commentsList.append(comment)
  
      }
    })
})