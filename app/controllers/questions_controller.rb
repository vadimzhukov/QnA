class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :delete_file]

  def index
    @questions = Question.all.order(created_at: :asc)
  end

  def show
    @answer = @question.answers.new
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
    redirect_to @question, notice: "The question was successfully saved"
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
    @question = Question.with_attached_files.preload(:answers).find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy],
                                                    reward_attributes: [:name, :image, :_destroy])
  end

  def question_params_files
    params.require(:question).permit(files: [])
  end

  def add_files
    @question.files.attach(params[:question][:files]) if params[:question][:files].present?
  end
end
