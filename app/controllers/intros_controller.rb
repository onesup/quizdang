class IntrosController < ApplicationController
  after_action :verify_authorized, except: :index

  def index
    @questions = Question.random_order.includes(:user, :photo, :reputations).limit(50)
  end
end
