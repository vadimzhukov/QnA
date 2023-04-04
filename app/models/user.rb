class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def reward_user(reward)
    rewards << reward if reward&.persisted?
  end

  def author_of?(record)
    record.respond_to?(:user) && id == record.user_id
  end
end
