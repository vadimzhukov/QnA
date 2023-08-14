class SearchController < ApplicationController
  before_action :search_params, only: [:find]

  def find
    @search_results = model_klass.search params[:search_query]
  end

  private
  def model_klass
    params[:search_entity] == "all" ? "ThinkingSphinx".constantize : params[:search_entity].downcase.capitalize.singularize.constantize
  end

  def search_params
    params.permit(:search_query, :search_entity)
  end
  
end
