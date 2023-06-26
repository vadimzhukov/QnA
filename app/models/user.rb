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
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    return identity.user if identity
      
    user = User.where(email: auth.info[:email]).first

    unless user
      password = Devise.friendly_token[0, 10]
      user = User.create(email: auth[:info][:email], password: password)
    end

    identity = user.identities.create(provider: auth.provider, uid: auth.uid)
    
    user
  end
end
