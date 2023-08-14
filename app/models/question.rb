class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscriptable
  
  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy, as: :rewardable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :subscribe_author

  scope :created_yesterday, -> do 
    where("created_at > ? AND created_at < ?", 
    DateTime.now.beginning_of_day - 1.day, 
    DateTime.now.beginning_of_day 
    ).sort
  end

  def best_answer
    answers.order(updated_at: :desc).where(best: true).first
  end

  def not_best_answers
    answers.where(best: false)
  end

  def subscribe_author
    self.subscriptions.create(user_id: self.user.id)
  end
end
