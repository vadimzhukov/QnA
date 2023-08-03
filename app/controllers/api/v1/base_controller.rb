class Api::V1::BaseController < ApplicationController
  skip_forgery_protection
  before_action :doorkeeper_authorize!

  protected
  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
  
  private
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end