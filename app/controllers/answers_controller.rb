class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :edit, :update, :destroy]
  before_action :load_question, only: [:create, :update, :destroy]

  def show; end

  def new
    @answer = Answer.new
  end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question), notice: "Answer successfully created."
    else
      flash[:alert] = "Error. Answer was not saved."
      redirect_to question_path(@question)
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to answer_path(id: @answer.id)
    else
      render :edit
    end
  end

  def destroy
    @answer.delete
    redirect_to @question
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
