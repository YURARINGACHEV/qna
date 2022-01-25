class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_question, only: [:create]
  before_action :answer, only: %i[update mark_as_best destroy]
  after_action :publish_answer, only: %i[create]

  include Voted

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def mark_as_best
    @question = @answer.question
    @answer.mark_as_best
  end

  def destroy
    @answer.destroy if current_user&.author?(@answer)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{params[:question_id]}/answers",
      {
        partial: ApplicationController.render(
          partial: 'answers/other_answer', locals: { answer: @answer }
        ),
        current_user_id: current_user.id,
        answer: @answer
      }
    )
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  helper_method :resource

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end
end
