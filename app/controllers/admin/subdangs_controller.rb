class Admin::SubdangsController < AdminController
  def index
    @subdangs = Subdang.all.page(params[:page]).per(100)
  end
end
