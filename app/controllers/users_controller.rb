class UsersController < ApplicationController
  before_action :load_user, only: [:update]

  load_and_authorize_resource

  def index
    @users = User.where("admin = ?", false).order(:id)
  end

  def update
    @user.update!(user_params)
    redirect_to users_path, notice: "User #{@user.email} updated successfully."
  end

  private
    def user_params
      params.require(:user).permit(:admin)
    end

    def load_user
      @user = User.find(params[:id])
    end
end
