class Admin::QuizzesController < AdminController
  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = Quiz.new
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.user = current_user
    if @quiz.save
      redirect_to [:admin, @quiz]
    else
      render :new
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])
    if @quiz.update(quiz_params)
      redirect_to [:admin, @quiz]
    else
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy!
    redirect_to [:admin, Quiz]
  end

  private

  def quiz_params
    params[:quiz].permit(:title, :description, :featured_image, :remove_featured_image)
  end
end
