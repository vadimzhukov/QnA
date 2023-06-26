class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards
  has_many :identities, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def reward_user(reward)
    rewards << reward if reward&.persisted?
  end

  def author_of?(record)
    record.respond_to?(:user) && id == record.user_id
  end

  def self.find_for_oauth(auth)
    identity = Identities.where(provider: auth.provider, uid: auth.uid)
    identity.user if identity
  end
end
