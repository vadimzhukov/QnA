class EmailRegistrationsController < ApplicationController
  def new
    @email_registration = EmailRegistration.new(oauth_provider: params['oauth_provider'], oauth_uid: params['oauth_uid'])
  end

  def create
    user = User.find_by(email: email_registration_params[:email])
    identity = Identity.find_by(provider: email_registration_params[:oauth_provider], uid: email_registration_params[:oauth_uid])
    if user && !identity
      identity = user.identities.create!(provider: email_registration_params[:oauth_provider], uid: email_registration_params[:oauth_uid])
      redirect_to new_user_session_path, notice: "Success! Now you can log in via social network"
      return
    end
    confirmation_token = Devise.friendly_token[0, 10]
    email_registration = EmailRegistration.new(email_registration_params.merge(confirmation_token: confirmation_token))
    if email_registration.save
      EmailRegistrationMailer.confirm_email_registration(email_registration).deliver_now
      flash[:notice] = "Confirmation instructions were sent to your email, to sign in with social networks please finalize email registration"
      redirect_to new_user_session_path
    else
      render :new
    end
  end

  def confirm
    registration = EmailRegistration.find_by(id: params['id'], email: params['email'], confirmation_token: params['confirmation_token'])
    if registration
      registration.update!(confirmed: true, confirmed_at: DateTime.now)
      user = User.find_by(email: registration.email)
      unless user
        user = User.create_by_email(registration.email)
      end
      identity = user.identities.create!(provider: registration.oauth_provider, uid: registration.oauth_uid)
      redirect_to new_user_session_path, notice: "Your account was successfully created, please login"
    else
      redirect_to new_user_session_path, alert: "Wrong confirmation parameters, email registration confirmation failed"
    end
  end

  private
  def email_registration_params
    params.require(:email_registration).permit(:email, :oauth_provider, :oauth_uid)
  end

end
