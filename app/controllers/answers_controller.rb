class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  before_action :load_answer, only: [:show, :edit, :update, :destroy, :mark_as_best, :delete_file]
  before_action :load_question, only: [:new, :create, :mark_as_best, :publish_answer]

  after_action :publish_answer, only: [:create]
  
  def new
    @answer = @question.answers.new
  end

  def edit; end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    add_files
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
    add_files
  end

  def destroy
    @answer.destroy
  end

  def mark_as_best
    @answer.mark_as_best
    redirect_to @question
  end

  def delete_file
    @answer.files.find(params[:answer][:file].to_i).purge
    @answer.reload
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id, :best,
                                   links_attributes: [:id, :name, :url, :_destroy])
  end

  def answer_params_files
    params.require(:answer).permit(files: [])
  end

  def add_files
    @answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
  end

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map { |file| { name: file.filename.to_s, url: url_for(file) } }
    links = @answer.links.map { |link| { name: link.name, url: link.url } }

    votes = {
            votes_sum: @question.votes_sum,
            like_url: polymorphic_path(@question, action: :like),
            dislike_url: polymorphic_path(@question, action: :dislike),
            reset_url: polymorphic_path(@question, action: :reset_vote)
            }

    ActionCable.server.broadcast(
      "question_channel_#{@question.id}", 
      { answer: @answer.attributes.merge(files: files, 
                                          links: links, 
                                          votes: votes,
                                          url: url_for(@answer),
                                          author_id: @answer.user.id
                                        ),
        sid: session.id.public_id
      }      
    )
  end

end
