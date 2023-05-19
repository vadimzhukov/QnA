class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :delete_file]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all.order(created_at: :asc)
  end

  def show
    @answer = @question.answers.new
    gon.push({
      :question_id => @question.id
    })

    logger.info "-==== session public id: #{session.id.public_id} ====-"
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.reward = Reward.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    return unless @question.save

    add_files
    redirect_to @question, notice: "The question was succesfully saved"
  end

  def update
    @question.update(question_params)
    add_files
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def delete_file
    @question.files.find(params[:question][:file].to_i).purge
    @question.reload
  end

  private

  def load_question
    @question = Question.with_attached_files.preload(:answers).preload(:votes).find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy],
                                                    reward_attributes: [:id, :name, :image, :_destroy])
  end

  def question_params_files
    params.require(:question).permit(files: [])
  end

  def add_files
    @question.files.attach(params[:question][:files]) if params[:question][:files].present?
  end

  def publish_question
    return if @question.errors.any?

    gon.push({
      :current_user_id => current_user.id
    })

    files = @question.files.map { |file| { name: file.filename.to_s, url: url_for(file) } }
    links = @question.links.map { |link| { name: link.name, url: link.url } }
    votes = {
            votes_sum: @question.votes_sum,
            like_url: polymorphic_path(@question, action: :like),
            dislike_url: polymorphic_path(@question, action: :dislike),
            reset_url: polymorphic_path(@question, action: :reset_vote)
            }


    ActionCable.server.broadcast(
      "questions_channel", 
      { question: @question.attributes.merge(files: files, 
                                            links: links, 
                                            votes: votes,
                                            reward: @question.reward, 
                                            url: url_for(@question), 
                                            ) 
      }      
    )
  end
end
