class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :update, :destroy]
  after_action :publish_question, only: [:create]

  authorize_resource
  
  def index
    @questions = Question.all
    render json: @questions, each_serializer: Api::V1::QuestionsSerializer
  end

  def show
    render json: @question, serializer: Api::V1::QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(title: params[:title], body: params[:body])
    
    if @question.save
      render json: @question, status: 200
    else
      render json: { error: 'Bad request' }, status: 400 
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, status: 200
    else
      render json: { error: 'Bad request' }, status: 400 
    end
  end

  def destroy
    authorize! :destroy, @question
    if @question.destroy
      head :ok
    else
      render json: { error: 'Bad request' }, status: 400 
    end
  end

  private
  def load_question
    @question = Question.preload(:votes).find(params[:id])
  end

  def question_params
    params.permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy],
                                                    reward_attributes: [:id, :name, :image, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    
    votes = {
      votes_sum: @question.votes_sum,
      like_url: polymorphic_path(@question, action: :like),
      dislike_url: polymorphic_path(@question, action: :dislike),
      reset_url: polymorphic_path(@question, action: :reset_vote)
      }

    ActionCable.server.broadcast(
      "questions_channel", 
      { question: @question.attributes.merge.merge(votes: votes,
                                                  url: url_for(@question) 
                                                  )
      }      
    )
  end
end