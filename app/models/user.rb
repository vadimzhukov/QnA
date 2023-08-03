class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards
  has_many :identities, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :twitter]

  def reward_user(reward)
    rewards << reward if reward&.persisted?
  end

  def self.find_for_oauth(auth)
   User::FindForOauth.new(auth).call
  end

  def self.create_by_email(email)
    password = Devise.friendly_token[0, 10]
    user = User.create!(email: email, password: password)
  end

  def admin?
   self.admin
  end

end
