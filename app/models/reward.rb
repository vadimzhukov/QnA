class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, :image, presence: true
end
