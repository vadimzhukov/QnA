module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def voted_by_user?(user)
    self.votes.where(user: user).any?
  end

  def user_liked?(user)
    self.votes.where(user: user, direction: true).any? || false
  end

  def user_disliked?(user)
    self.votes.where(user: user, direction: false).any? || false
  end

  def votes_sum
    self.votes.reduce(0) { |sum, val|  val.direction.present? ? sum += 1 : sum -= 1 } || 0
  end
end