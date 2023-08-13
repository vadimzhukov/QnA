class Subscription < ApplicationRecord
  belongs_to :subscriptable, polymorphic: true
  belongs_to :user

  validates :subscriptable, :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:subscriptable_type, :subscriptable_id] }

  def self.exists?(user, object)
    object.subscriptions.where("user_id = ?", user.id).any?
  end
end
