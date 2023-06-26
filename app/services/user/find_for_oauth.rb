class User::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    return identity.user if identity

    user = User.where(email: auth.info[:email]).first
    unless user
      password = Devise.friendly_token[0, 10]
      user = User.create!(email: auth[:info][:email], password: password)
    end

    identity = user.identities.create(provider: auth.provider, uid: auth.uid)
    
    user
  end
end
