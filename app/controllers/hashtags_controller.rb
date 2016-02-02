# == Schema Information
#
# Table name: hashtags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#  user_id    :integer
#

class HashtagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :destroy]
  before_action :set_hashtag, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, only: [:edit, :destroy]

  def index
    @hashtags = Hashtag.by_count.includes(:children)
  end

  def show
    @hashtag = Hashtag.find(params[:id])
    @questions = @hashtag.questions.desc_by_id
      .includes(:user, :photo, :reputations).page(params[:page])
  end

  def new
    @hashtag = Hashtag.new
  end

  def edit
  end

  def create
    @hashtag = Hashtag.new(hashtag_params)
    @hashtag.user = current_user
    @hashtag.save
  end

  def update
  end

  def destroy
  end

  private

  def set_hashtag
    @hashtag = Hashtag.find(params[:id])
  end

  def hashtag_params
    params[:hashtag].permit(:name)
  end
end
