class NotificationMailer < ApplicationMailer
  def new_answer_broadcast_notification(user, answer)
    @answer = answer
    
    mail to: user.email, subject: "New answer for question you subscribed on QnA"
  end

  def questions_digest(user, questions)
    @questions = questions
    mail to: user.email, subject: "New questions posted yesterday on QnA"
  end
end
