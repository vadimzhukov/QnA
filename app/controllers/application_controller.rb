class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |ex|
    redirect_back(fallback_location: root_path)
    flash[:alert] = "You are not authorized to do/view this."
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
