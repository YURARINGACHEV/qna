class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  authorize_resource
  
  def destroy
    @link = Link.find(params[:id])
    if current_user&.author?(@link.linkable)
      @link.destroy
    end
  end
end