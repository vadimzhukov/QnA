class User::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    return identity.user if identity
    email = auth.info[:email]
    user = User.where(email: email).first
    if !user && auth.info[:email].present?
      user = User.create_by_email(email)
    end
    identity = user&.identities&.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
