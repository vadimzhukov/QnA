class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_inclusion_of :correct, in: [true, false]

  def self.best
    where("rating > 0").order(rating: :desc, updated_at: :desc).first
  end
end
