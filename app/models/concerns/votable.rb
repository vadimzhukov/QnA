module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def votes_sum_by_user(user)
    votes.where(user:).reduce(0) { |sum, val| val.direction.present? ? sum += 1 : sum -= 1 } || 0
  end

  def votes_sum
    votes.reduce(0) { |sum, val| val.direction.present? ? sum += 1 : sum -= 1 } || 0
  end
end
