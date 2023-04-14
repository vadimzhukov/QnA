module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike, :reset_vote]
  end

  def like
    return if @votable.voted_by_user?(current_user)

    vote = @votable.votes.new(user: current_user, direction: true)
    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, votes_sum: @votable.votes_sum,
                         current_user_voted: true, vote_direction: true }
        end
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessible_entity }
      end
    end
  end

  def dislike
    return if @votable.voted_by_user?(current_user)

    vote = @votable.votes.new(user: current_user, direction: false)
    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, votes_sum: @votable.votes_sum, current_user_voted: true,
                         vote_direction: false }
        end
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessible_entity }
      end
    end
  end

  def reset_vote
    return unless @votable.voted_by_user?(current_user)

    vote = @votable.votes.find_by(user: current_user)
    respond_to do |format|
      if vote.destroy
        format.json do
          render json: { id: @votable.id, votes_sum: @votable.votes_sum, current_user_voted: false,
                         vote_direction: nil }
        end
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessible_entity }
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
