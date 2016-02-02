class Admin::PhotosController < AdminController
  def index
    @photos = Photo.all.page(params[:page]).per(100)
  end
end
