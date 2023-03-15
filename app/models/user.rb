class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def reward_user(answer)
    reward = Reward.find_by(rewardable_type: "Question", rewardable_id: answer.question.id)
    self.rewards << Reward.find_by(rewardable_type: "Question", rewardable_id: answer.question.id) if reward
  end
end
