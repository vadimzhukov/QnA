class QuestionsDigestNotificationJob < ApplicationJob
  queue_as :default

  def perform
    Questions::DailyDigest.new.send_yesterday_questions_digest
  end
end
