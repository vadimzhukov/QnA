class OauthCallbacksController < Devise::OmniauthCallbacksController
 
  def github
    oauth_sign_in('github')
  end

  def twitter
    oauth_sign_in('twitter')
  end

  private 

  def oauth_sign_in(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if !@user.present?
      auth = request.env['omniauth.auth']
      redirect_to new_email_registration_path(oauth_provider: auth['provider'], oauth_uid: auth['uid'])
      
    elsif @user.persisted?
      sign_in_and_redirect @user, event: :authenticate
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to new_user_session_path, alert: 'Login was unseccessful'
    end
  end

end
