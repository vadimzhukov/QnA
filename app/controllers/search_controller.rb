class SearchController < ApplicationController
  def find
    @search_results = model_klass.search params[:query]
  end

  private
  def model_klass
    params[:entity] == "all" ? "ThinkingSphinx".constantize : params[:entity].downcase.capitalize.constantize
  end
  
end
