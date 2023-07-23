class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    logger.info "-----subscribed to questions_channel stream-------"
    queue = "questions_channel"
    stream_from queue
    
  end
end
