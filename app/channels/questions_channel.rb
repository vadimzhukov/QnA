class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    logger.info "-----subscribed to questions_channel stream-------"
    stream_from "questions_channel"
  end
end
