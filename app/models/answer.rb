class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_inclusion_of :correct, in: [true, false]

  def mark_as_best
    transaction do
      Answer.where(question_id: question.id).update_all(rating: 0)
      update(rating: 1) 
    end
  end
end
