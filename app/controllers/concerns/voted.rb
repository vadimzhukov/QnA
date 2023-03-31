module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike]
  end

  def like
    return if @votable.voted_by_user?(current_user)

    vote = @votable.votes.new(user: current_user)
    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, votes_count: @votable.votes.count,
                         current_user_voted: @votable.voted_by_user?(current_user) }
        end
      end
    end
  end

  def dislike
    return unless @votable.voted_by_user?(current_user)

    vote = @votable.votes.find_by(user: current_user)

    respond_to do |format|
      if vote.destroy
        format.json do
          render json: { id: @votable.id, votes_count: @votable.votes.count,
                         current_user_voted: @votable.voted_by_user?(current_user) }
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
