module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike, :reset_vote]

    load_and_authorize_resource
  end

  def like
    return unless @votable.votes_sum_by_user(current_user) == 0

    vote = @votable.votes.new(user: current_user, direction: true)
    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, votes_sum: @votable.votes_sum,
            votes_sum_by_user: 1 }
        end
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessible_entity }
      end
    end
  end

  def dislike
    return unless @votable.votes_sum_by_user(current_user) == 0

    vote = @votable.votes.new(user: current_user, direction: false)
    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, votes_sum: @votable.votes_sum, votes_sum_by_user: -1,
                          }
        end
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessible_entity }
      end
    end
  end

  def reset_vote
    return if @votable.votes_sum_by_user(current_user) == 0

    vote = @votable.votes.find_by(user: current_user)
    respond_to do |format|
      if vote.destroy
        format.json do
          render json: { id: @votable.id, votes_sum: @votable.votes_sum, votes_sum_by_user: 0 }
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
