# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  unique_id  :string(255)      not null
#  source     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PhotosController < ApplicationController
  before_action :authenticate_user!, only: [:vote]
  after_action :verify_authorized, only: :vote

  def index
    @photos = Photo.desc_by_id.all.page(params[:page])
  end

  def vote
    @photo = Photo.find(params[:id])
    authorize @photo
    @photo.add_or_delete_evaluation(:votes, 1, current_user)
    @photo.touch
  end
end
