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
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def mark_as_best
    if (!@question.answers.best || @answer == @question.answers.best)
      @answer.update(answer_params)
    else
      @question.answers.best.update_attribute(:rating, 0)
      @answer.update(answer_params)
    end

    if (answer_params[:rating] == "1")
      redirect_to @question
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id, :rating)
  end
end
