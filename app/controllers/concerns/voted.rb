module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[vote_up vote_down unvote]
  end

  def vote_up
    return error_response if current_user.author?(@votable)
    return error_response if @votable.vote_of?(current_user)

    @votable.vote_up(current_user)
    success_response
  end

  def vote_down
    return error_response if current_user.author?(@votable)
    return error_response if @votable.vote_of?(current_user)

    @votable.vote_down(current_user)
    success_response
  end

  def unvote
    return error_response if current_user.author?(@votable)

    @votable.unvote(current_user)
    success_response
  end

  private

  def success_response
    render json: {
      id: @votable.id,
      name: @votable.class.name.underscore,
      rating: @votable.rating
    }
  end

  def error_response
    render json: { message: 'yuo cannot vote. you are an author or unregistered user' }, status: :forbidden
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end