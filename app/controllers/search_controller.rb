class SearchController < ApplicationController
  before_action :skip_authorization

  def index
    if request.post?
      render 'index.post.js.erb'
    else
      if params[:q]
        scope = QuestionsIndex.query(match: { '_all': params[:q] })
          .load(scope: -> { includes(:user, :photo, :reputations) })
        @questions = scope.page(params[:page])
      end
    end
  end
end
