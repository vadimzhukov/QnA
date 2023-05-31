class CommentsChannel < ApplicationCable::Channel
  def subscribed
    logger.info "-----subscribed to comments_channel stream-------"
    stream_from "comments_channel"
    # stream_from "some_channel"
  end
end
