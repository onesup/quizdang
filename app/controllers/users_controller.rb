# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  username               :string(255)      default(""), not null
#  avatar                 :string(255)
#

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  after_action :verify_authorized, except: [:index, :show]

  def index
    @users = User.by_karma
  end

  def show
    @user = User.find(params[:id])

    if params[:filter] == 'author'
      @questions = @user.questions.desc_by_id.includes(:photo, :reputations).page(params[:page])
    elsif params[:filter] == 'participant'
      @questions = @user.participant_questions.desc_by_id.includes(:user, :photo, :reputations).page(params[:page])
    elsif params[:filter] == 'favorite'
      @questions = Question.evaluated_by(:favorites, @user).includes(:user, :photo, :reputations).page(params[:page])
    elsif params[:filter] == 'vote'
      @questions = Question.evaluated_by(:votes, @user).includes(:user, :photo, :reputations).page(params[:page])
    else
      @questions = @user.questions.desc_by_id.includes(:photo, :reputations).page(params[:page])
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    @user.update(user_params)
  end

  private

  def user_params
    params[:user].permit(:name, :avatar, :remove_avatar)
  end
end
