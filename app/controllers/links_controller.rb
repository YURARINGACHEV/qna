class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :link

  def destroy
    link.destroy
  end

  private

  def link
    @link = Link.find(params[:id])
  end

  # authorize_resource
  
  # def destroy
  #   @link = Link.find(params[:id])
  #   if current_user&.author?(@link.linkable)
  #     @link.destroy
  #   end
  # end
end