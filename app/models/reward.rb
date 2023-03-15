class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true
  belongs_to :user, optional: true

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates :name, :image, presence: true
end
