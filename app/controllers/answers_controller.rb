class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :mark_as_best]
  before_action :load_question, only: [:new, :create, :mark_as_best]

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

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id, :rating)
  end

  def answer_params_files
    params.require(:answer).permit(files: [])
  end
  def add_files
    @answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
  end
end
