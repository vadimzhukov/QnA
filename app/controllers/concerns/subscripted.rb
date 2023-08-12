module Subscripted
  extend ActiveSupport::Concern

  included do
    before_action :set_subscripted, only: [:add_subscription, :delete_subscription]
  end

  def add_subscription
    @subscription = @subscriptable.subscriptions.new(user_id: current_user.id)

    if @subscription.save
      redirect_to @subscriptable, notice: "Вы успешно подписаны"
    else
      redirect_to @subscriptable, alert: "Возникла ошибка, подписка не оформлена"
    end
  end

  def delete_subscription
    @subscription = @subscriptable.subscriptions.find_by(user_id: current_user.id)
    if @subscription.destroy
      redirect_to @subscriptable, notice: "Вы успешно отписались"
    else
      redirect_to @subscriptable, alert: "Возникла ошибка, отписаться не удалось"
    end
  end


  private
  def model_klass
    controller_name.classify.constantize
  end
  def set_subscripted
    @subscriptable = model_klass.find(params[:id])
  end
 
end
