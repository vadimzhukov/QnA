class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
  validates_inclusion_of :correct, in: [true, false]
end
