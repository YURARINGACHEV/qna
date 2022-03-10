class SearchController < ApplicationController
  def index
    @result = SearchService.search_by(params[:body], params[:type])
  end
end