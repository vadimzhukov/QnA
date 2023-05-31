class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy, as: :rewardable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def best_answer
    answers.order(updated_at: :desc).where(best: true).first
  end

  def not_best_answers
    answers.where(best: false)
  end
end
