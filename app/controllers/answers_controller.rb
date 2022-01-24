class AnswersController < ApplicationController  

  authorize_resource
  before_action :authenticate_user!, only: [:create, :destroy]
  # before_action :find_question, only: [:create]
  # before_action :find_answer, only: [:update, :mark_as_best, :destroy]
  # before_action :answer
  after_action :publish_answer, only: %i[create]

  include Voted

  authorize_resource

  def create
    @answer = question.answers.create(answer_params.merge( user_id: current_user.id))
  end

  def update
    if authorize! :update, answer
      answer.update(answer_params)
      @question = answer.question
    end
  end

  def mark_as_best
    answer.mark_as_best
    @question = answer.question
  end

  def destroy
    if current_user&.author?(answer)
      answer.destroy
    end
  end

  private

  def question
    Question.find(params[:question_id] || answer.question_id)
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
    gon.answer_id = @answer.id
    @answer
  end

  helper_method :answer
  helper_method :question

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{params[:question_id]}/answers",
      {
        partial: ApplicationController.render(
          partial: 'answers/other_answer',
          locals: { answer: @answer, current_user: current_user }
        )
      }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
