class CommentsChannel < ApplicationCable::Channel
  def subscribed
    logger.info "-----subscribed to comments_channel stream-------"
    queue = "comments_channel"
    stream_from queue
    
  end
end
