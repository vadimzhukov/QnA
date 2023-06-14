module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commented, only: [:add_comment, :destroy]
    after_action :publish_comment, only: [:add_comment]
  end

  def add_comment
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))

    status = nil
    response_body = nil
  
    if @comment.save
      status = 200
      response_body = successfull_response_body_for(@comment)
    else
      status = :unprocessible_entity
      response_body = {
        errors: {
          full_messages: @comment.errors.full_messages
        },
        error_alert: "Error of adding of comment for #{controller_name.singularize} with id #{@commentable.id}"
      }
    end

    response_with_json(status, response_body)
  end

  def delete_comment
    @comment.destroy
  end

  private
  
  def comment_params
    params.permit(:body)
  end

  def successfull_response_body_for(comment)
    {
      message: "Comment was successfully added to #{controller_name.singularize} with id #{@commentable.id}",
      comment: {
        body: comment.body,
        author_email: comment.user.email,
        comment_date_time: comment.created_at
      }
  }
  end

  def response_with_json(status, response_body)
    respond_to do |format|
      format.json do
        render json: { status: status, body: response_body }
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commented
    @commentable = model_klass.find(params[:id])
  end

  def publish_comment
    @comment.valid?
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_channel", {
      comment: {
        id: @comment.id,
        body: @comment.body,
        author_email: @comment.user.email,
        date: @comment.created_at,
        commentable_type: @comment.commentable_type,
        commentable_id: @comment.commentable_id,
        author_id: @comment.user_id
      },
      sid: session.id.public_id
  })

  end

end