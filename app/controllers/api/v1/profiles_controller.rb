class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, :self_profile
    render json: current_resource_owner
  end

  def others
    authorize! :read, :other_profiles
    @others = User.all.where("id != ?", current_resource_owner.id)
    render json: @others
  end
end
