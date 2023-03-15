class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def reward_user(answer)
    reward = answer.question.reward
    self.rewards << reward if reward
  end

  def author_of?(record)
   record.respond_to?(:user) && self.id == record.user.id
  end
end
