class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show, :update, :destroy]
  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: Api::V1::AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(body: params[:body], user_id: current_resource_owner.id)
    
    if @answer.save
      render json: @answer, status: 200
    else
      render json: { error: 'Bad request' }, status: 400 
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: 200
    else
      render json: { error: 'Bad request' }, status: 400 
    end
  end

  def destroy
    if @answer.destroy
      head :ok
    else
      render json: { error: 'Bad request' }, status: 400 
    end
  end

  private
  def load_question
    @question = Question.preload(:votes).find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.permit(:body, :question_id, links_attributes: [:id, :name, :url, :_destroy])
  end
end