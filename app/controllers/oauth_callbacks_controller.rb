class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
   
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authenticate
      set_flash_message(:notice, :success, kind: 'github') if is_navigational_format?
    else
      redirect_to new_user_session_path, alert: 'Login was unseccessful'
    end
  end
end
