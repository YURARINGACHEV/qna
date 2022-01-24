class RewardsController < ApplicationController  
  before_action :authenticate_user!, only: :index

  skip_authorization_check

  def index
    @rewards = Reward.all
  end
end