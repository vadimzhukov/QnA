class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:show, :edit, :update, :destroy]
  before_action :load_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def edit; end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id)
  end
end
