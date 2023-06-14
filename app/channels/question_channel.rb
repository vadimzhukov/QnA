class QuestionChannel < ApplicationCable::Channel
  def subscribed
    logger.info "-----subscribed to question_channel_#{params[:question_id]} stream-------"
    stream_from "question_channel_#{params[:question_id]}"
    # stream_from "some_channel"
  end
end
