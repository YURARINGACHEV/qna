class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def set_commentable
    @commentable = Answer.find_by(id: params[:answer_id]) || Question.find_by(id: params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    id = @comment.commentable_type.to_sym == :Answer ? @comment.commentable.question_id : @comment.commentable.id
    ActionCable.server.broadcast(
      "comments-#{id}", {
        partial: ApplicationController.render(partial: 'comments/comment',
                                              locals: {
                                                comment: @comment, current_user: nil
                                              }),
        comment: @comment
      }
    )
  end
end
