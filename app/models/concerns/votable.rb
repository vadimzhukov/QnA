module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def voted_by_user?(user)
    votes.where(user: user).any?
  end

  def user_votes_count(user)
    votes.where(user: user).count
  end
end