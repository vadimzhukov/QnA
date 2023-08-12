class Questions::DailyDigest
  def send_yesterday_questions_digest
    @questions = Question.created_yesterday

    User.find_each(batch_size: 500) do |user|
      NotificationMailer.questions_digest(user, @questions).deliver_later
    end
  end
end
