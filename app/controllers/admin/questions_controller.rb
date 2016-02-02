class Admin::QuestionsController < AdminController
  def index
    @questions = Question.includes(:quiz, :subdang, :options).page(params[:page]).per(100)
  end

  def new
    @quiz = Quiz.find(params[:quiz_id])
    @question = @quiz.questions.new
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])
    @question = @quiz.questions.new(question_params)
    if @question.save
      redirect_to [:admin, @quiz]
    else
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to [:admin, @question.quiz]
    else
      render :edit
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy!
    redirect_to [:admin, @question.quiz]
  end

  private

  def question_params
    params[:question].permit(
      :text, options_attributes: [:id, :text, :_destroy]
    )
  end
end
