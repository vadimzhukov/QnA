class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(subscripted_object, notified_object)
    # Получить список подписанных пользователей за исключением автора объекта
    notified_users = User.subscribed(subscripted_object).filter{|user| user.id != notified_object.user_id}
    
    # Каждому участнику списка отправить email с содержанием объекта-нотификации
    notified_users.each do |user|
      if notified_object.class == Answer 
        @answer = notified_object
        NotificationMailer.new_answer_broadcast_notification(user, @answer).deliver_later 
      end
    end
  end


end
