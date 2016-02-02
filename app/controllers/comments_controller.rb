# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :text(65535)      not null
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer
#

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_commentable
  after_action :verify_authorized, only: [:edit, :update, :destroy, :vote]

  def edit
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def update
    @comment = Comment.find(params[:id])
    authorize @comment
    @comment.update(comment_params)
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @comment.destroy!
  end

  def vote
    @comment = Comment.find(params[:id])
    authorize @comment
    unless @comment.owner?(current_user)
      @comment.add_or_delete_evaluation(:votes, 1, current_user)
      @comment.touch
    end
  end

  private

  def comment_params
    params[:comment].permit('text')
  end

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  # alternative option:
  # def load_commentable
  #   klass = [Article, Photo, Event].detect { |c| params["#{c.name.underscore}_id"] }
  #   @commentable = klass.find(params["#{klass.name.underscore}_id"])
  # end
end
