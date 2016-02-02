# == Schema Information
#
# Table name: subdangs
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  featured_image :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#

class SubdangsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :destroy]
  before_action :set_subdang, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, only: [:edit, :destroy]

  def index
    @subdangs = Subdang.all
  end

  def show
    @questions = @subdang.questions.desc_by_id
      .includes(:user, :photo, :reputations).page(params[:page])
  end

  def create
    @subdang = Subdang.new(subdang_params)
    @subdang.user = current_user
    @subdang.save
  end

  private

  def set_subdang
    @subdang = Subdang.find(params[:id])
  end

  def subdang_params
    params[:subdang].permit(:name)
  end
end
