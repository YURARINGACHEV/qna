class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = question.answers
    render json: @answers
  end

  def create
    @answer = question.answers.new(answers_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer
  end

  def update
    if answer.update(answers_params)
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
    render json: { messages: ['Answer deleted.'] }
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :question

  def answer
    @answer = Answer.find(params[:id])
  end

  helper_method :answer

  def answers_params
    params.require(:answer).permit(:body)
  end
end
