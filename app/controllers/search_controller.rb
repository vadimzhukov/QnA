class SearchController < ApplicationController
  before_action :search_params, only: [:find]

  def find
    @search_results = model_klass.search params[:query]
  end

  private
  def model_klass
    params[:entity] == "all" ? "ThinkingSphinx".constantize : params[:entity].downcase.capitalize.constantize
  end

  def search_params
    params.permit(:query, :entity)
  end
  
end
