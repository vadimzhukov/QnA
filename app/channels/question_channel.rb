class QuestionChannel < ApplicationCable::Channel
  def subscribed
    logger.info "-----subscribed to question_channel_#{params[:question_id]} stream-------"
    queue = "question_channel_#{params[:question_id]}"
    stream_from queue
   
  end
end
