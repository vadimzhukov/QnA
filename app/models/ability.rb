# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    guest_permissions
    return unless user.present?
    user_permissions(user)
    return unless user.admin
    admin_permissions(user)
  end

  private 
  def guest_permissions
    can :read, [Question, Answer, Comment]
  end

  def user_permissions(user)
    guest_permissions
    can [:create, :add_comment], [Question, Answer]
    can [:edit, :update, :destroy], [Question, Answer], { user_id: user.id }
    can :delete_file, [Question, Answer], { user_id: user.id }
    can [:like, :dislike, :reset_vote], [Question, Answer] do |votable| 
      votable.user_id != user.id
    end
    can :mark_as_best, Answer do |answer|
      question = answer.question
      question.user_id == user.id 
    end
    can :read, :oauth_applications
    can :read, :self_profile
    
    can :add_subscription, Question do |subscriptable|
      !Subscription.exists?(user, subscriptable)
    end
    can :delete_subscription, Question do |subscriptable|
      Subscription.exists?(user, subscriptable)
    end
  end

  def admin_permissions(user)
    user_permissions(user)
    can :manage, :all
    
    cannot :delete_subscription, Question do |subscriptable|
      !Subscription.exists?(user, subscriptable)
    end
    cannot :add_subscription, Question do |subscriptable|
      Subscription.exists?(user, subscriptable)
    end
  end
  
end
